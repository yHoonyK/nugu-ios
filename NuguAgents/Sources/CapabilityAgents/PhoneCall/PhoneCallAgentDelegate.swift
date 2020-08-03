//
//  PhoneCallAgentDelegate.swift
//  NuguAgents
//
//  Created by yonghoonKwon on 2020/05/12.
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

/// The  `PhoneCallAgentDelegate` protocol defines methods that action when `PhoneCallAgent` receives a directive or needs a context.
public protocol PhoneCallAgentDelegate: class {
    /// Request the state of calls for context.
    /// This function should return as soon as possible to reduce request delay.
    func phoneCallAgentRequestState() -> PhoneCallState
    
    /// Request `PhoneCallTemplate` for context.
    /// This function should return as soon as possible to reduce request delay.
    func phoneCallAgentRequestTemplate() -> PhoneCallTemplate?
    
    /// Tells the delegate that `PhoneCallAgent` received 'SendCandidates' directive.
    /// - Parameters:
    ///   - item: The `item` is object that received the directive.
    ///   - dialogRequestId: The `dialogRequestId` for the directive.
    func phoneCallAgentDidReceiveSendCandidates(item: PhoneCallCandidatesItem, dialogRequestId: String)
    
    /// Tells the delegate that `PhoneCallAgent` received 'MakeCall' directive.
    /// - Parameters:
    ///   - callType: `PhoneCallType` about the
    ///   - recipient: `PhoneCallPerson` about the recipient.
    ///   - dialogRequestId: The `dialogRequestId` for the directive.
    /// - Returns: `PhoneCallErrorCode` when client cannot make a call.
    ///            Return nil if the make a call succeeds
    func phoneCallAgentDidReceiveMakeCall(callType: PhoneCallType, recipient: PhoneCallPerson, dialogRequestId: String) -> PhoneCallErrorCode?
}
