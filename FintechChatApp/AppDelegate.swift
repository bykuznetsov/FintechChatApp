//
//  AppDelegate.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        LogginClass.printAppLifeCycleEvent("Application moved from <Not running> to <Inactive>: <\(#function)>")
    
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Inactive> to <Active>: <\(#function)>")
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Active> to <Inactive>: <\(#function)>")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Inactive> to <Background>: <\(#function)>")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Background> to <Inactive>: <\(#function)>")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Background> to <Suspended>: <\(#function)>")
    }
    

}

