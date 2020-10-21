//
//  LoggingClass.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

//Class for logs of life cycle of ViewController's and App.

class LogginClass {
    
    private static var uniqueInstance: LogginClass?
    
    private static var printingAppEvents: Bool = false
    private static var printingVCEvents: Bool = true
    
    private init() {}
    
    static func printAppLifeCycleEvent(_ description: String, _ event: String) {
        if self.printingAppEvents {
            print("\(description): \(event)")
        } else {
            
        }
    }
    
    static func printVCLifeCycleEvent(_ description: String?, _ event: String, _ nameOfVC: String) {
        if self.printingVCEvents {
            print("\(description ?? ""): \(event) in \(nameOfVC)")
        } else {
            
        }
    }

}
