//
//  DisplayAgentTests.swift
//  NuguTests
//
//  Created by yonghoonKwon on 2020/03/02.
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

import XCTest

@testable import NuguAgents
@testable import NuguCore

class DisplayAgentTests: XCTestCase {
    
    // NuguCore(Mock)
    let focusManager: FocusManageable = MockFocusManager()
    let upstreamDataSender: UpstreamDataSendable = MockStreamDataRouter()
    let playSyncManager: PlaySyncManageable = MockPlaySyncManager()
    let contextManager: ContextManageable = MockContextManager()
    let directiveSequencer: DirectiveSequenceable = MockDirectiveSequencer()
    
    // NuguAgents
    lazy var displayAgent: DisplayAgent = DisplayAgent(
        upstreamDataSender: upstreamDataSender,
        playSyncManager: playSyncManager,
        contextManager: contextManager,
        directiveSequencer: directiveSequencer
    )
    
    // Override
    override func setUp() {
        
    }
    
    override func tearDown() {
        
    }
    
    // MARK: Contexts
    
    func testContext() {
        /*
         {
             "Display": {
                 "version": "1.1",
                 "playServiceId": "{{STRING}}",
                 "token": "{{STRING}}"
             }
         }
         */
        
        let contextExpectation = expectation(description: "Get contextInfo")
        displayAgent.contextInfoRequestContext { [weak self] (contextInfo) in
            guard let self = self else {
                XCTFail("self is nil")
                return
            }
            
            guard let contextInfo = contextInfo else {
                XCTFail("contextInfo is nil")
                return
            }
            
            XCTAssertEqual(contextInfo.name, self.displayAgent.capabilityAgentProperty.name)
            
            guard let payload = contextInfo.payload as? [String: Any] else {
                XCTFail("payload is nil or not dictionary")
                return
            }
            
            XCTAssertEqual(payload["version"] as? String, self.displayAgent.capabilityAgentProperty.version)
            
            // TODO: - Check more context information
            
            contextExpectation.fulfill()
        }
        
        // Check if it can get `contextInfo` within 50ms (include processing)
        wait(for: [contextExpectation], timeout: 0.05)
    }
}