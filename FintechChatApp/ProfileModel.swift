//
//  ProfileModel.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

protocol IProfileModelDelegate: class {
    
}

protocol IProfileModel: class {
    var delegate: IProfileModelDelegate? { get set }
    
    func gcdGetProfileName() -> String?
    func gcdGetProfileDescription() -> String?
    func gcdGetProfileImage() -> UIImage?
    func gcdUpdateProfileName(with name: String)
    func gcdUpdateProfileDescription(with description: String)
    func gcdUpdateProfileImage(with image: UIImage?)
    
    func operationGetProfileName() -> String?
    func operationGetProfileDescription() -> String?
    func operationGetProfileImage() -> UIImage?
    func operationUpdateProfileName(with name: String)
    func operationUpdateProfileDescription(with description: String)
    func operationUpdateProfileImage(with image: UIImage?)
    
    func getTheme() -> Theme
}

class ProfileModel: IProfileModel {
    
    weak var delegate: IProfileModelDelegate?
    
    let gcdProfileService: IProfileService
    let operationProfileService: IProfileService
    let themeService: IThemeService
    
    init(gcdProfileService: IProfileService, operationProfileService: IProfileService, themeService: IThemeService) {
        self.gcdProfileService = gcdProfileService
        self.operationProfileService = operationProfileService
        self.themeService = themeService
    }
    
    func gcdGetProfileName() -> String? {
        self.gcdProfileService.getProfileName()
    }
    
    func gcdGetProfileDescription() -> String? {
        self.gcdProfileService.getProfileDescription()
    }
    
    func gcdGetProfileImage() -> UIImage? {
        self.gcdProfileService.getProfileImage()
    }
    
    func gcdUpdateProfileName(with name: String) {
        self.gcdProfileService.updateProfileName(with: name)
    }
    
    func gcdUpdateProfileDescription(with description: String) {
        self.gcdProfileService.updateProfileDescription(with: description)
    }
    
    func gcdUpdateProfileImage(with image: UIImage?) {
        self.gcdProfileService.updateProfileImage(with: image)
    }
    
    func operationGetProfileName() -> String? {
        self.operationProfileService.getProfileName()
    }
    
    func operationGetProfileDescription() -> String? {
        self.operationProfileService.getProfileDescription()
    }
    
    func operationGetProfileImage() -> UIImage? {
        self.operationProfileService.getProfileImage()
    }
    
    func operationUpdateProfileName(with name: String) {
        self.operationProfileService.updateProfileName(with: name)
    }
    
    func operationUpdateProfileDescription(with description: String) {
        self.operationProfileService.updateProfileDescription(with: description)
    }
    
    func operationUpdateProfileImage(with image: UIImage?) {
        self.operationProfileService.updateProfileImage(with: image)
    }
    
    func getTheme() -> Theme {
        return self.themeService.getTheme()
    }
    
}
