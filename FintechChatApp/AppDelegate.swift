//
//  AppDelegate.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private let rootAssembly = RootAssembly()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        LogginClass.printAppLifeCycleEvent("Application moved from <> to <>", #function)
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Firebase Configure
        FirebaseApp.configure()
        
        //Window Configure
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let conversationListVC = rootAssembly.presentationAssembly.conversationListViewController()
        let conversationListVCWithNavigation = UINavigationController(rootViewController: conversationListVC)
        conversationListVCWithNavigation.navigationBar.prefersLargeTitles = true
        window?.rootViewController = conversationListVCWithNavigation
        window?.makeKeyAndVisible()
        
//        window?.addGestureRecognizer(panGestureRecognizer)
//        window?.subviews.forEach({$0.addGestureRecognizer(panGestureRecognizer)})
        
        //CoreDataStack Configure
        let coreDataStack = CoreDataStack.shared
        
        coreDataStack.enableObservers()
        coreDataStack.didUpdateDataBase = { stack in
            stack.printDatabaseStatistics()
        }
        
        LogginClass.printAppLifeCycleEvent("Application moved from <Not running> to <Inactive>", #function)
        
        return true
    }
    
//    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
//            let gestureRecognizer = UIPanGestureRecognizer()
//            gestureRecognizer.addTarget(self, action: #selector(handlePan))
//            return gestureRecognizer
//    }()
//    
//    @objc func handlePan(sender: UIPanGestureRecognizer) {
//        
//        tinkoffEmitterLayer.emitterPosition = sender.location(in: sender.view)
//        
//        if sender.state == .ended {
//            tinkoffEmitterLayer.lifetime = 0
//        } else if sender.state == .began {
//            if let view = sender.view {
//                showParticle(in: view)
//            }
//            tinkoffEmitterLayer.lifetime = 1.0
//        }
//        
//    }
//    
//    lazy var tinkoffEmitterCell: CAEmitterCell = {
//        var tinkoffCell = CAEmitterCell()
//        tinkoffCell.contents = UIImage(named: "tinkoffParticle")?.cgImage
//        tinkoffCell.scale = 0.05
//        tinkoffCell.scaleRange = 0
//        tinkoffCell.emissionLongitude = 90
//        tinkoffCell.emissionRange = .pi
//        tinkoffCell.alphaSpeed = -0.5
//        tinkoffCell.lifetime = 1
//        tinkoffCell.birthRate = 8
//        tinkoffCell.velocity = -50.0
//        tinkoffCell.velocityRange = -10
//        tinkoffCell.xAcceleration = 0
//        tinkoffCell.yAcceleration = 0
//        tinkoffCell.spin = -0.5
//        tinkoffCell.spinRange = 1.0
//        return tinkoffCell
//    }()
//    
//    lazy var tinkoffEmitterLayer: CAEmitterLayer = {
//        let particleEmitter = CAEmitterLayer()
//        particleEmitter.emitterPosition = CGPoint(x: window?.bounds.width ?? 0 / 2.0, y: window?.bounds.height ?? 0 / 4.0)
//        particleEmitter.emitterSize = CGSize(width: 5, height: 5)
//        particleEmitter.emitterShape = CAEmitterLayerEmitterShape.circle
//        particleEmitter.beginTime = CACurrentMediaTime()
//        particleEmitter.emitterMode = CAEmitterLayerEmitterMode.outline
//        particleEmitter.timeOffset = CFTimeInterval(2)//CFTimeInterval(arc4random_uniform(6) + 5)
//        particleEmitter.emitterCells = [self.tinkoffEmitterCell]
//        return particleEmitter
//    }()
//    
//    func showParticle(in view: UIView) {
//        view.layer.addSublayer(tinkoffEmitterLayer)
//    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Inactive> to <Active>", #function)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Active> to <Inactive>", #function)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Inactive> to <Background>", #function)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Background> to <Inactive>", #function)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        LogginClass.printAppLifeCycleEvent("Application moved from <Background> to <Suspended>", #function)
    }
    
}
