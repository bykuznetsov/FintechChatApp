//
//  LoggingClass.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

//Singleton
class LogginClass {
    
    private static var uniqueInstance: LogginClass?
    
    private static var printingAppEvents: Bool = true
    private static var printingVCEvents: Bool = true
    
    private init() {}
    
    static func shared() -> LogginClass {
        if uniqueInstance == nil {
            uniqueInstance = LogginClass()
        }
        return uniqueInstance!
    }
    
    static func printAppLifeCycleEvent(_ description: String){
        if self.printingAppEvents{
            print(description)
        } else {
            
        }
    }
    
    static func printVCLifeCycleEvent(_ event: String, _ nameOfVC: String){
        if self.printingVCEvents{
            print("\(event) in \(nameOfVC)")
        } else {
            
        }
    }

}
