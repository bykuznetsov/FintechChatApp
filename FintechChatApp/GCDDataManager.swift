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
    
    let savingSerialQueue = DispatchQueue(label: "com.bykuznetsov.savingSerialQueue",qos: .background, attributes: .concurrent)
    
    override var profileName: String? {
        get {
            self.initProfileName()
        }
        set {}
    }

    override var profileDescription: String? {
        get {
            self.initProfileDescription()
        }
        set {}
    }

    override var profileImage: UIImage? {
        get {
            self.initProfileImage()
        }
        set {}
    }

    override func updateProfileName(with name: String) {
        self.savingSerialQueue.sync {
            super.updateProfileName(with: name)
        }
    }
    
    override func updateProfileDescription(with description: String) {
        self.savingSerialQueue.sync {
            super.updateProfileDescription(with: description)
        }
    }
    
    override func updateProfileImage(with image: UIImage?) {
        self.savingSerialQueue.sync {
            super.updateProfileImage(with: image)
        }
    }
    
    override func initProfileName() -> String {
        self.savingSerialQueue.sync {
            super.initProfileName()
        }
    }
    
    override func initProfileDescription() -> String {
        self.savingSerialQueue.sync {
            super.initProfileDescription()
        }
    }
    
    override func initProfileImage() -> UIImage? {
        self.savingSerialQueue.sync {
            super.initProfileImage()
        }
    }
    
    //Make some UI changes (activity indicator, alert's and etc.)
    //Because savingSerialQueue is SERIAL Queue
    func returnToMainQueue ( _ someMethod: @escaping () -> () ) {
        self.savingSerialQueue.sync {
            DispatchQueue.main.async {
                someMethod()
            }
        }
    }
    
}
