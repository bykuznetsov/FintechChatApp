//
//  ProfileDataManager.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ProfileDataManager {
    
    //From this properties we well get profile information
    var profileName: ProfileName?
    var profileDescription: ProfileDescription?
    var profileImage: UIImage?
    
    //Path's and file name's
    private let pathToProfileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileName.plist")
    private let pathToProfileDescription = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileDescription.plist")
    private let profileImageName: String = "profileImage"
    
    func updateProfileName(with name: String) {
        
        self.profileName = ProfileName(name: name)
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        //Write to file
        do {
            let data = try encoder.encode(self.profileName)
            try data.write(to: self.pathToProfileName)
            return
        } catch {
            //print(error)
            return
        }
        //Write to file
    }
    
    func updateProfileDescription(with description: String) {
        
        self.profileDescription = ProfileDescription(description: description)
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        //Write to file
        do {
            let data = try encoder.encode(self.profileDescription)
            try data.write(to: self.pathToProfileDescription)
            return
        } catch {
            //print(error)
            return
        }
        //Write to file
    }
    
    func updateProfileImage(with image: UIImage?) {
        
        self.profileImage = image
        
        guard let data = image?.jpegData(compressionQuality: 1) ?? image?.pngData() else {
            return
        }
        
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        
        //Write to file
        do {
            if let urlOfImage = directory.appendingPathComponent(self.profileImageName) {
                try data.write(to: urlOfImage)
            }
            return
        } catch {
            //print(error.localizedDescription)
            return
        }
        //Write to file
        
    }
    
    func initProfileName() -> Bool {
        
        do {
            
            let data = try Data(contentsOf: self.pathToProfileName)
            let decoder = PropertyListDecoder()
            
            do {
                self.profileName = try decoder.decode(ProfileName.self, from: data)
                return true
                
            } catch {
                //print(error)
                return false
            }
            
        } catch {
            //print(error)
            return false
        }
    }
    
    func initProfileDescription() -> Bool {
        
        do {
            
            let data = try Data(contentsOf: self.pathToProfileDescription)
            let decoder = PropertyListDecoder()
            
            do {
                self.profileDescription = try decoder.decode(ProfileDescription.self, from: data)
                //print(self.profileDescription?.description)
                return true
                
            } catch {
                //print(error)
                return false
            }
            
        } catch {
            //print(error)
            return false
        }
    }
    
    func initProfileImage() -> Bool {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            self.profileImage = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(self.profileImageName).path)
            return true
        }
        return false
    }
    
    func initAllProperties() {
        if self.initProfileName() {
            
        } else {
            self.initProfileNameWithPrimaryData()
        }
        
        if self.initProfileDescription() {
            
        } else {
            self.initProfileDescriptionWithPrimaryData()
        }
        
        if self.initProfileImage() {
            
        } else {
            self.initProfileImageWithPrimaryData()
        }
    }
    
    
}

//MARK: - Primary data for our Profile properties (use it when open App first time)

extension ProfileDataManager {
    
    func initProfileNameWithPrimaryData() {
        //Init Profile Name.
        self.profileName = ProfileName(name: "Marina Dudarenko")
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        //Write to file
        do {
            let data = try encoder.encode(self.profileName)
            try data.write(to: self.pathToProfileName)
        } catch {
            //print(error)
        }
        //Write to file
    }
    
    func initProfileDescriptionWithPrimaryData() {
        //Init Profile Description.
        self.profileDescription = ProfileDescription(description: "UX/UI Design, IOS Development, UX/UI Design, IOS Development, UX/UI Design, IOS Development, UX/UI Design, IOS Development, UX/UI Design, IOS Development,UX/UI Design, IOS Development, UX/UI Design, IOS Development,")
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        //Write to file
        do {
            let data = try encoder.encode(self.profileDescription)
            try data.write(to: self.pathToProfileDescription)
        } catch {
            //print(error)
        }
        //Write to file
    }
    
    func initProfileImageWithPrimaryData() {
        //Init Profile Image.
        self.profileImage = nil
    }
    
}
