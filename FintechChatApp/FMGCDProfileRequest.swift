//
//  FMGCDProfileRequest.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class FMGCDProfileRequest: IFMProfileRequest {
    
    let savingSerialQueue = DispatchQueue(label: "com.bykuznetsov.savingSerialQueue", qos: .background, attributes: .concurrent)
    
    let fmProfileRequest: IFMProfileRequest
    
    init(fmProfileRequest: IFMProfileRequest) {
        self.fmProfileRequest = fmProfileRequest
    }
    
    var profileName: String? {
        self.savingSerialQueue.sync {
            return fmProfileRequest.profileName
        }
    }
    
    var profileDescription: String? {
        self.savingSerialQueue.sync {
            return fmProfileRequest.profileDescription
        }
    }
    
    var profileImage: UIImage? {
        self.savingSerialQueue.sync {
            return fmProfileRequest.profileImage
        }
    }
    
    func updateProfileName(with name: String) {
        self.savingSerialQueue.sync {
            fmProfileRequest.updateProfileName(with: name)
        }
    }
    
    func updateProfileDescription(with description: String) {
        self.savingSerialQueue.sync {
            fmProfileRequest.updateProfileDescription(with: description)
        }
    }
    
    func updateProfileImage(with image: UIImage?) {
        self.savingSerialQueue.sync {
            fmProfileRequest.updateProfileImage(with: image)
        }
    }
        
}
