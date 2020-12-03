//
//  FMGCDProfileRequestMock.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 01.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import Foundation
import UIKit

class FMProfileRequestMock: IFMProfileRequest {
    
    var gettingProfileNameCount: Int = 0
    var gettingProfileDescriptionCount: Int = 0
    var gettingProfileImageCount: Int = 0
    var settingProfileNameCount: Int = 0
    var settingProfileDescriptionCount: Int = 0
    var settingProfileImageCount: Int = 0
    
    var settedProfileName: String?
    var settedProfileDescription: String?
    var settedProfileImage: UIImage?

    var profileName: String? {
        gettingProfileNameCount += 1
        return nil
    }
    
    var profileDescription: String? {
        gettingProfileDescriptionCount += 1
        return nil
    }
    
    var profileImage: UIImage? {
        gettingProfileImageCount += 1
        return nil
    }
    
    func updateProfileName(with name: String) {
        settingProfileNameCount += 1
        settedProfileName = name
    }
    
    func updateProfileDescription(with description: String) {
        settingProfileDescriptionCount += 1
        settedProfileDescription = description
    }
    
    func updateProfileImage(with image: UIImage?) {
        settingProfileImageCount += 1
        settedProfileImage = image
    }
    
}
