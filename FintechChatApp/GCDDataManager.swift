//
//  GCDDataManager.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 14.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class GCDDataManager: ProfileDataManager {
    
    let savingSerialQueue = DispatchQueue(label: "com.bykuznetsov.savingSerialQueue", qos: .background)
    
    //When init() -> check existing data and init properties
    override init() {
        super.init()
        
        self.initAllProperties()
    }
    
    override func initAllProperties() {
        
        self.savingSerialQueue.async {
            super.initAllProperties()
        }
        
    }
    
    override func updateProfileName(with name: String) {
        self.savingSerialQueue.async {
            super.updateProfileName(with: name)
        }
    }
    
    override func updateProfileDescription(with description: String) {
        self.savingSerialQueue.async {
            super.updateProfileDescription(with: description)
        }
    }
    
    override func updateProfileImage(with image: UIImage?) {
        self.savingSerialQueue.async {
            super.updateProfileImage(with: image)
        }
    }
    
    //Make some UI changes (activity indicator, alert's and etc.)
    //Because savingSerialQueue is SERIAL Queue
    func returnToMainQueue ( _ someMethod: @escaping () -> () ) {
        self.savingSerialQueue.async {
            DispatchQueue.main.async {
                someMethod()
            }
        }
    }
    
}
