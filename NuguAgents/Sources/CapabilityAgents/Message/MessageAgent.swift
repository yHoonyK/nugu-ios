//
//  MessageAgent.swift
//  NuguAgents
//
//  Created by yonghoonKwon on 2020/05/25.
//  Copyright (c) 2020 SK Telecom Co., Ltd. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

import NuguCore

public class MessageAgent: MessageAgentProtocol {
    public var capabilityAgentProperty: CapabilityAgentProperty = CapabilityAgentProperty(category: .message, version: "1.0")
    
    // MessageAgentProtocol
    public weak var delegate: MessageAgentDelegate?
    
    private var recipientInteded: MessageRecipient?
    
    // private
    private let directiveSequencer: DirectiveSequenceable
    private let contextManager: ContextManageable
    private let upstreamDataSender: UpstreamDataSendable
    
    // Handleable Directive
    private lazy var handleableDirectiveInfos: [DirectiveHandleInfo] = [
        DirectiveHandleInfo(namespace: capabilityAgentProperty.name, name: "SendCandidates", blockingPolicy: BlockingPolicy(medium: .none, isBlocking: false), directiveHandler: handleSendCandidates),
        DirectiveHandleInfo(namespace: capabilityAgentProperty.name, name: "SendMessage", blockingPolicy: BlockingPolicy(medium: .none, isBlocking: false), directiveHandler: handleSendMessage)
    ]
    
    public init(
        directiveSequencer: DirectiveSequenceable,
        contextManager: ContextManageable,
        upstreamDataSender: UpstreamDataSendable
    ) {
        self.directiveSequencer = directiveSequencer
        self.contextManager = contextManager
        self.upstreamDataSender = upstreamDataSender
        
        contextManager.add(delegate: self)
        directiveSequencer.add(directiveHandleInfos: handleableDirectiveInfos.asDictionary)
    }
}

// MARK: - ContextInfoDelegate

extension MessageAgent: ContextInfoDelegate {
    public func contextInfoRequestContext(completion: @escaping (ContextInfo?) -> Void) {
        let displayItem = delegate?.messageAgentRequestDisplayItem()
        
        var payload: [String: AnyHashable?] = [
            "version": capabilityAgentProperty.version,
            "readActivity": "IDLE" // TODO: - 필요할지 검토
        ]
        
        if let recipientInteded = recipientInteded,
            let recipientIntededData = try? JSONEncoder().encode(recipientInteded),
            let recipientIntededObject = try? JSONSerialization.jsonObject(with: recipientIntededData, options: []) as? [String: AnyHashable] {
            
            payload["recipientInteded"] = recipientIntededObject
        }
        
        if let candidates = displayItem,
            let candidatesData = try? JSONEncoder().encode(candidates),
            let candidatesArray = try? JSONSerialization.jsonObject(with: candidatesData, options: []) as? [[String: AnyHashable]] {
            
            payload["candidates"] = candidatesArray
        }
        
        completion(
            ContextInfo(
                contextType: .capability,
                name: capabilityAgentProperty.name,
                payload: payload.compactMapValues { $0 }
            )
        )
    }
}

// MARK: - Private(Directive)

private extension MessageAgent {
    func handleSendCandidates() -> HandleDirective {
        return { [weak self] directive, completion in
            defer { completion() }
            
            guard let self = self else { return }
            
            guard let payloadDictionary = directive.payloadDictionary else {
                log.error("Invalid payload")
                return
            }
            
            guard let playServiceId = payloadDictionary["playServiceId"] as? String else {
                log.error("Invalid playServiceId in payload")
                return
            }
            
            var recipient: MessageRecipient?
            if let recipientDictionary = payloadDictionary["recipientIntended"] as? [String: AnyHashable],
                let recipientData = try? JSONSerialization.data(withJSONObject: recipientDictionary, options: []) {
                recipient = try? JSONDecoder().decode(MessageRecipient.self, from: recipientData)
            }
            
            var candidates: [MessageContact]?
            if let candidatesArray = payloadDictionary["candidates"] as? [[String: AnyHashable]],
                let candidatesData = try? JSONSerialization.data(withJSONObject: candidatesArray, options: []) {
                candidates = try? JSONDecoder().decode([MessageContact].self, from: candidatesData)
            }
            
            let resultCandidates = self.delegate?.messageAgentDidReceiveSendCandidates(
                recipient: recipient,
                candidates: candidates
            )
            
            self.contextManager.getContexts(namespace: self.capabilityAgentProperty.name) { [weak self] contextPayload in
                guard let self = self else { return }
                
                self.upstreamDataSender.sendEvent(
                    Event(
                        playServiceId: playServiceId,
                        typeInfo: .candidatesListed(candidates: resultCandidates)
                    ).makeEventMessage(
                        property: self.capabilityAgentProperty,
                        dialogRequestId: TimeUUID().hexString,
                        contextPayload: contextPayload
                    )
                )
                
                // TODO: - Clear Recipient
            }
        }
    }
    
    func handleSendMessage() -> HandleDirective {
        return { [weak self] directive, completion in
            defer { completion() }
            
            guard let self = self else { return }
            
            guard let payloadDictionary = directive.payloadDictionary else {
                log.error("Invalid payload")
                return
            }
            
            guard let playServiceId = payloadDictionary["playServiceId"] as? String else {
                log.error("Invalid playServiceId in payload")
                return
            }
            
            guard let recipientDictionary = payloadDictionary["recipient"] as? [String: AnyHashable],
                let recipientData = try? JSONSerialization.data(withJSONObject: recipientDictionary, options: []),
                let recipientContact = try? JSONDecoder().decode(MessageContact.self, from: recipientData) else {
                    log.error("Invalid recipient in payload")
                    return
            }
            
            let eventTypeInfo: Event.TypeInfo
            if let errorCode = self.delegate?.messageAgentDidReceiveSendMessage(recipient: recipientContact) {
                // Failed to sendMessage
                eventTypeInfo = .sendMessageFailed(recipient: recipientContact, errorCode: errorCode)
            } else {
                // Success to sendMessage
                eventTypeInfo = .sendMessageSucceeded(recipient: recipientContact)
            }
            
            self.contextManager.getContexts(namespace: self.capabilityAgentProperty.name) { [weak self] contextPayload in
                guard let self = self else { return }
                
                self.upstreamDataSender.sendEvent(
                    Event(
                        playServiceId: playServiceId,
                        typeInfo: eventTypeInfo
                    ).makeEventMessage(
                        property: self.capabilityAgentProperty,
                        dialogRequestId: TimeUUID().hexString,
                        contextPayload: contextPayload
                    )
                )
            }
        }
    }
}
