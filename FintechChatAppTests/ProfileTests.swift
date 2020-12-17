//
//  ProfileTests.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 17.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import XCTest

class ProfileTests: XCTestCase {
    
    private var fmProfileRequestMock = FMProfileRequestMock()
    
    private var profileGCDService: IProfileService?
    private var profileOperationService: IProfileService?
    
    private var profileName: String?
    private var profileDescription: String?
    private var profileImage: UIImage?
    
    override func setUp() {
        super.setUp()
        
        profileGCDService = GCDProfileService(fmGCDProfileRequest: fmProfileRequestMock)
        profileOperationService = OperationProfileService(fmOperationProfileRequest: fmProfileRequestMock)

        profileName = "Nikita Kuznetsov"
        profileDescription = "Hello World!"
        profileImage = UIImage(imageLiteralResourceName: "tinkoffParticle")
    }
    
    // MARK: - ProfileService

    func testGCDProfileService() throws {
        
        //Act
        _ = profileGCDService?.getProfileName()
        _ = profileGCDService?.getProfileDescription()
        _ = profileGCDService?.getProfileImage()
        _ = profileGCDService?.updateProfileName(with: profileName ?? "")
        _ = profileGCDService?.updateProfileDescription(with: profileDescription ?? "")
        _ = profileGCDService?.updateProfileImage(with: profileImage)
        
        //Assert
        XCTAssertEqual(fmProfileRequestMock.gettingProfileNameCount, 1)
        XCTAssertEqual(fmProfileRequestMock.gettingProfileDescriptionCount, 1)
        XCTAssertEqual(fmProfileRequestMock.gettingProfileImageCount, 1)
        XCTAssertEqual(fmProfileRequestMock.settingProfileNameCount, 1)
        XCTAssertEqual(fmProfileRequestMock.settingProfileDescriptionCount, 1)
        XCTAssertEqual(fmProfileRequestMock.settingProfileImageCount, 1)

        XCTAssertEqual(fmProfileRequestMock.settedProfileName, profileName)
        XCTAssertEqual(fmProfileRequestMock.settedProfileDescription, profileDescription)
        XCTAssertEqual(fmProfileRequestMock.settedProfileImage, profileImage)
        
    }
    
    func testOperationProfileService() throws {
        //Act
        _ = profileOperationService?.getProfileName()
        _ = profileOperationService?.getProfileDescription()
        _ = profileOperationService?.getProfileImage()
        _ = profileOperationService?.updateProfileName(with: profileName ?? "")
        _ = profileOperationService?.updateProfileDescription(with: profileDescription ?? "")
        _ = profileOperationService?.updateProfileImage(with: profileImage)
        
        //Assert
        XCTAssertEqual(fmProfileRequestMock.gettingProfileNameCount, 1)
        XCTAssertEqual(fmProfileRequestMock.gettingProfileDescriptionCount, 1)
        XCTAssertEqual(fmProfileRequestMock.gettingProfileImageCount, 1)
        XCTAssertEqual(fmProfileRequestMock.settingProfileNameCount, 1)
        XCTAssertEqual(fmProfileRequestMock.settingProfileDescriptionCount, 1)
        XCTAssertEqual(fmProfileRequestMock.settingProfileImageCount, 1)

        XCTAssertEqual(fmProfileRequestMock.settedProfileName, profileName)
        XCTAssertEqual(fmProfileRequestMock.settedProfileDescription, profileDescription)
        XCTAssertEqual(fmProfileRequestMock.settedProfileImage, profileImage)
    }

}
