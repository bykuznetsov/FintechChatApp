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
    
    let savingSerialQueue = OperationQueue()
    
    override init() {
        super.init()
        
        self.savingSerialQueue.maxConcurrentOperationCount = 1 //Make queue serial
        
        self.initAllProperties()
    }
    
    override func initAllProperties() {
        
        self.savingSerialQueue.addOperation {
            super.initAllProperties()
        }
        
    }
    
    override func updateProfileName(with name: String) {
        
        self.savingSerialQueue.addOperation {
            super.updateProfileName(with: name)
        }
        
    }
    
    override func updateProfileDescription(with description: String) {
        
        self.savingSerialQueue.addOperation {
            super.updateProfileDescription(with: description)
        }
    }
    
    override func updateProfileImage(with image: UIImage?) {
        
        self.savingSerialQueue.addOperation {
            super.updateProfileImage(with: image)
        }
        
    }
    
    //Make some UI changes (activity indicator, alert's and etc.)
    //Because savingQueue is SERIAL Queue
    func returnToMainQueue ( _ someMethod: @escaping () -> () ) {
        self.savingSerialQueue.addOperation {
            OperationQueue.main.addOperation {
                someMethod()
            }
        }
    }
    
}
