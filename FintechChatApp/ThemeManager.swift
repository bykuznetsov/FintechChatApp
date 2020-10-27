//
//  ThemeManager.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 07.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ThemeManager {
    
    enum Theme {
        case classic
        case day
        case night
    }
    
    static let shared = ThemeManager()
    
    var currentTheme: Theme = .classic
    
    let defaults = UserDefaults.standard
    
    func getTheme() -> Theme {
        return self.currentTheme
    }
    
    func updateTheme(new theme: Theme) {
        DispatchQueue.global(qos: .background).sync {
            //Update currentTheme
            self.currentTheme = theme
            
            //Update in UserDefaults
            self.defaults.set( String(describing: theme), forKey: "Theme")
        }
    }
    
    private init() {
        
        //When init -> update currentTheme with UserDefaults
        guard let themeFromDefaults = defaults.string(forKey: "Theme") else { return }

        if themeFromDefaults == "classic" {
            self.currentTheme = .classic
        } else if themeFromDefaults == "day" {
            self.currentTheme = .day
        } else if themeFromDefaults == "night" {
            self.currentTheme = .night
        }
        
    }
    
}
