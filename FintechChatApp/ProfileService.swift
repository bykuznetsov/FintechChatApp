//
//  ProfileService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

protocol IProfileService {
    func getProfileName() -> String?
    func getProfileDescription() -> String?
    func getProfileImage() -> UIImage?
    
    func updateProfileName(with name: String)
    func updateProfileDescription(with description: String)
    func updateProfileImage(with image: UIImage?)
}

///Service for getting profile data from FileManager
///Using (Core Components):
///-FileManager: FMGCDProfileRequest

class GCDProfileService: IProfileService {
    
    let fmGCDProfileRequest: IFMProfileRequest
    
    init(fmGCDProfileRequest: IFMProfileRequest) {
        self.fmGCDProfileRequest = fmGCDProfileRequest
    }
    
    func getProfileName() -> String? {
        self.fmGCDProfileRequest.profileName
    }
    
    func getProfileDescription() -> String? {
        self.fmGCDProfileRequest.profileDescription
    }
    
    func getProfileImage() -> UIImage? {
        self.fmGCDProfileRequest.profileImage
    }
    
    func updateProfileName(with name: String) {
        self.fmGCDProfileRequest.updateProfileName(with: name)
    }
    
    func updateProfileDescription(with description: String) {
        self.fmGCDProfileRequest.updateProfileDescription(with: description)
    }
    
    func updateProfileImage(with image: UIImage?) {
        self.fmGCDProfileRequest.updateProfileImage(with: image)
    }
    
}

///Service for getting profile data from FileManager
///Using (Core Components):
///-FileManager: FMOperationProfileRequest

class OperationProfileService: IProfileService {
    
    let fmOperationProfileRequest: IFMProfileRequest
    
    init(fmOperationProfileRequest: IFMProfileRequest) {
        self.fmOperationProfileRequest = fmOperationProfileRequest
    }
    
    func getProfileName() -> String? {
        self.fmOperationProfileRequest.profileName
    }
    
    func getProfileDescription() -> String? {
        self.fmOperationProfileRequest.profileDescription
    }
    
    func getProfileImage() -> UIImage? {
        self.fmOperationProfileRequest.profileImage
    }
    
    func updateProfileName(with name: String) {
        self.fmOperationProfileRequest.updateProfileName(with: name)
    }
    
    func updateProfileDescription(with description: String) {
        self.fmOperationProfileRequest.updateProfileDescription(with: description)
    }
    
    func updateProfileImage(with image: UIImage?) {
        self.fmOperationProfileRequest.updateProfileImage(with: image)
    }
    
}
