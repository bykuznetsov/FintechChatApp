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
    
    var profileName: String? {
        get {
            self.initProfileName()
        }
    }
    
    var profileDescription: String? {
        get {
            self.initProfileDescription()
        }
    }
    
    var profileImage: UIImage? {
        get {
            self.initProfileImage()
        }
    }
    
    //Path's and file name's
    private let pathToProfileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileName.plist")
    private let pathToProfileDescription = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileDescription.plist")
    private let profileImageName: String = "profileImage"
    
    func updateProfileName(with name: String) {
        
        let profileName = ProfileName(name: name)
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        //Write to file
        do {
            let data = try encoder.encode(profileName)
            try data.write(to: self.pathToProfileName)
            return
        } catch {
            return
        }
        //Write to file
    }
    
    func updateProfileDescription(with description: String) {
        
        let profileDescription = ProfileDescription(description: description)
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        
        //Write to file
        do {
            let data = try encoder.encode(profileDescription)
            try data.write(to: self.pathToProfileDescription)
            return
        } catch {
            return
        }
        //Write to file
    }
    
    func updateProfileImage(with image: UIImage?) {
        
        guard let data = image?.pngData() else {
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
            return
        }
        //Write to file
        
    }
    
    func initProfileName() -> String {
        
        do {
            
            let data = try Data(contentsOf: self.pathToProfileName)
            let decoder = PropertyListDecoder()
            
            do {
                
                let profileName: ProfileName?
                profileName = try decoder.decode(ProfileName.self, from: data)

                return profileName?.name ?? "Nikita Kuznetsov"
                
            } catch {
                return "Nikita Kuznetsov"
            }
            
        } catch {
            return "Nikita Kuznetsov"
        }
    }
    
    func initProfileDescription() -> String {
        
        do {
            
            let data = try Data(contentsOf: self.pathToProfileDescription)
            let decoder = PropertyListDecoder()
            
            do {
                
                let profileDescription: ProfileDescription?
                profileDescription = try decoder.decode(ProfileDescription.self, from: data)

                return profileDescription?.description ?? "Hello"
                
            } catch {
                return "Hello"
            }
            
        } catch {
            return "Hello"
        }
    }
    
    func initProfileImage() -> UIImage? {
        
        do {
            let dir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(self.profileImageName).path) ?? nil
            
        } catch {
            return nil
        }
        
    }
    
}

