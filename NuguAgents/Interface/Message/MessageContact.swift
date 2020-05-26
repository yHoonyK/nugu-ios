//
//  MessageContact.swift
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

public struct MessageContact: Codable {
    
    // MARK: MessageType
    
    public enum MessageType: String, Codable {
        case contact = "CONTACT"
        case exchange = "EXCHANGE"
        case t114 = "T114"
        case none = "NONE"
    }
    
    public let name: String?
    public let type: MessageType?
    public let number: String?
    public let profileImgUrl: String?
    public let message: String?
    public let time: String?
    public let token: String?
    public let score: String?
    
    public init(
        name: String?,
        type: MessageType?,
        number: String?,
        profileImgUrl: String?,
        message: String?,
        time: String?,
        token: String?,
        score: String?
    ) {
        self.name = name
        self.type = type
        self.number = number
        self.profileImgUrl = profileImgUrl
        self.message = message
        self.time = time
        self.token = token
        self.score = score
    }
}
