//
//  InterfaceController.swift
//  SampleApp-WatchOS WatchKit Extension
//
//  Created by YONG HOON KWON on 2020/04/02.
//  Copyright © 2020 SK Telecom Co., Ltd. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
