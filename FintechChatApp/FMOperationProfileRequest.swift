//
//  FMOperationProfileRequest.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class FMOperationProfileRequest: FMProfileRequestProtocol {
    
    let savingSerialQueue = OperationQueue()
    
    let fmProfileRequest: FMProfileRequestProtocol
    
    init(fmProfileRequest: FMProfileRequestProtocol) {
        self.fmProfileRequest = fmProfileRequest
        
        //Make queue serial
        self.savingSerialQueue.maxConcurrentOperationCount = 1
        self.savingSerialQueue.qualityOfService = .background
        self.savingSerialQueue.waitUntilAllOperationsAreFinished()
    }
    
    var profileName: String? {
        self.fmProfileRequest.profileName
    }
    
    var profileDescription: String? {
        self.fmProfileRequest.profileDescription
    }
    
    var profileImage: UIImage? {
        self.fmProfileRequest.profileImage
    }
    
    func updateProfileName(with name: String) {
        self.savingSerialQueue.addOperation {
            self.fmProfileRequest.updateProfileName(with: name)
        }
    }
    
    func updateProfileDescription(with description: String) {
        self.savingSerialQueue.addOperation {
            self.fmProfileRequest.updateProfileDescription(with: description)
        }
    }
    
    func updateProfileImage(with image: UIImage?) {
        self.savingSerialQueue.addOperation {
            self.fmProfileRequest.updateProfileImage(with: image)
        }
    }
    
}
