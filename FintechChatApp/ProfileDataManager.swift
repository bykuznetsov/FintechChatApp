//
//  ProfileDataManager.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 13.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

class ProfileDataManager {
    
    var profileName: ProfileName?
    var profileDescription: ProfileDescription?
    
    //When init() -> check existing data
    init() {
        
        print("Init ProfileDataManager")
        
        if ( initProfileName() && initProfileDescription() ) {
            
        } else {
            initProfileWithPrimaryData()
        }
    }
    
    deinit {
        print("Deinit ProfileDataManager")
    }
    
    func updateProfileName(with name: String) {
        
        self.profileName = ProfileName(name: name)

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let pathToProfileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileName.plist")

        //Вписываем в файл
        do {
            let data = try encoder.encode(self.profileName)
            try data.write(to: pathToProfileName)
        } catch {
            print(error)
        }
        //Вписываем в файл
    }
    
    func updateProfileDescription(with description: String) {
        
        self.profileDescription = ProfileDescription(description: description)

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let pathToProfileDescription = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileDescription.plist")

        //Вписываем в файл
        do {
            let data = try encoder.encode(self.profileDescription)
            try data.write(to: pathToProfileDescription)
        } catch {
            print(error)
        }
        //Вписываем в файл
    }
    
    func initProfileName() -> Bool {
        let pathToProfileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileName.plist")
        
        do {
            
            let data = try Data(contentsOf: pathToProfileName)
            let decoder = PropertyListDecoder()
            
            do {
                self.profileName = try decoder.decode(ProfileName.self, from: data)
                //print(self.profileName?.name)
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } catch {
            print(error)
            return false
        }
    }
    
    func initProfileDescription() -> Bool {
        let pathToProfileDescription = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileDescription.plist")
        
        do {
            
            let data = try Data(contentsOf: pathToProfileDescription)
            let decoder = PropertyListDecoder()
            
            do {
                self.profileDescription = try decoder.decode(ProfileDescription.self, from: data)
                //print(self.profileDescription?.description)
                return true
                
            } catch {
                print(error)
                return false
            }
            
        } catch {
            print(error)
            return false
        }
    }
    
    func initProfileWithPrimaryData() {
        
        self.profileName = ProfileName(name: "Marina Dudarenko")

        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml

        let pathToProfileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileName.plist")

        //Вписываем в файл
        do {
            let data = try encoder.encode(self.profileName)
            try data.write(to: pathToProfileName)
        } catch {
            print(error)
        }
        //Вписываем в файл
        
        self.profileDescription = ProfileDescription(description: "UX/UI Design, IOS Development, UX/UI Design, IOS Development, UX/UI Design, IOS Development, UX/UI Design, IOS Development, UX/UI Design, IOS Development,UX/UI Design, IOS Development, UX/UI Design, IOS Development,")
        let pathToProfileDescription = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("ProfileDescription.plist")
        
        
        //Вписываем в файл
        do {
            let data = try encoder.encode(self.profileDescription)
            try data.write(to: pathToProfileDescription)
        } catch {
            print(error)
        }
        //Вписываем в файл
        
    }
    
    
    
    
    
    
    
}










//if  let path = Bundle.main.path(forResource: "ProfileName", ofType: "plist"),
//    let xml = FileManager.default.contents(atPath: path),
//    let preferences = try? PropertyListDecoder().decode(ProfileName.self, from: xml)
//{
//    print(preferences.name)
//}
