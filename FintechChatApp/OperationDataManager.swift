//
//  OperationDataManager.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 14.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class OperationDataManager: ProfileDataManager {
    
    let savingQueue = OperationQueue()
    let initingQueue = OperationQueue()
    
    override init() {
        super.init()
        
        self.savingQueue.maxConcurrentOperationCount = 1 //Make queue serial
        self.initingQueue.maxConcurrentOperationCount = 3 //Make queue concurrent
        
        self.initAllProperties()
    }
    
    override func initAllProperties() {
        let initOperation = BlockOperation {
            super.initAllProperties()
        }
        initingQueue.addOperation(initOperation)
    }
    
    override func updateProfileName(with name: String) {
        
        self.savingQueue.addOperation {
            super.updateProfileName(with: name)
        }
        
    }
    
    override func updateProfileDescription(with description: String) {
        
        self.savingQueue.addOperation {
            super.updateProfileDescription(with: description)
        }
    }
    
    override func updateProfileImage(with image: UIImage?) {
        self.savingQueue.addOperation {
            super.updateProfileImage(with: image)
        }
    }
    
    //Make some UI changes (activity indicator, alert's and etc.)
    //Because savingQueue is SERIAL Queue
    func returnToMainQueue ( _ someMethod: @escaping () -> () ) {
        self.savingQueue.addOperation {
            OperationQueue.main.addOperation {
                someMethod()
            }
        }
    }
    
}
