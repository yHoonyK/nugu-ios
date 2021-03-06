//
//  AudioPlayerAgent+RequestPlayEvent.swift
//  NuguAgents
//
//  Created by jin kim on 2020/03/23.
//  Copyright © 2020 SK Telecom Co., Ltd. All rights reserved.
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

// MARK: - CapabilityEventAgentable

extension AudioPlayerAgent {
    public struct RequestPlayEvent {
        let requestPlayPayload: [String : AnyHashable]
        let typeInfo: TypeInfo
        
        public enum TypeInfo {
            case requestPlayCommandIssued
        }
    }
}

// MARK: - Eventable

extension AudioPlayerAgent.RequestPlayEvent: Eventable {
    public var payload: [String : AnyHashable] {
        return ["payload": requestPlayPayload]
    }
    
    public var name: String {
        return "RequestPlayCommandIssued"
    }
}
