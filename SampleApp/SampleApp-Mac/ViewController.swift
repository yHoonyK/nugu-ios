//
//  ViewController.swift
//  SampleApp-Mac
//
//  Created by yonghoonKwon on 2020/04/28.
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

import Cocoa

import NuguClientKit

class ViewController: NSViewController {

    lazy var client: NuguClient = NuguClient(delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

// MARK: - NuguClientDelegate
// TODO: -

extension ViewController: NuguClientDelegate {
    func nuguClientWillRequireAudioSession() -> Bool {
        return true
    }
    
    func nuguClientRequestAccessToken() -> String? {
        return nil
    }
}
