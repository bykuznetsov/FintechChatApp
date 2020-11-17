//
//  ThemeService.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

enum Theme {
    case classic
    case day
    case night
}

protocol IThemeService {
    func getTheme() -> Theme
    func setTheme(new theme: Theme)
}

///Service for saving and getting Theme of App
///Using (Core Components):
///-UserDefaults: UserDefaultsEntity

class ThemeService: IThemeService {
    
    let userDefaultsEntity: IUserDefaultsEntity
    
    init(userDefaultsEntity: IUserDefaultsEntity) {
        self.userDefaultsEntity = userDefaultsEntity
        
        guard let themeFromDefaults = userDefaultsEntity.defaults.string(forKey: "Theme") else { return }
        
        if themeFromDefaults == "classic" {
            self.currentTheme = .classic
        } else if themeFromDefaults == "day" {
            self.currentTheme = .day
        } else if themeFromDefaults == "night" {
            self.currentTheme = .night
        }
        
    }
    
    var currentTheme: Theme = .classic
    
    func getTheme() -> Theme {
        return self.currentTheme
    }
    
    func setTheme(new theme: Theme) {
        self.currentTheme = theme
        self.userDefaultsEntity.defaults.set(String(describing: theme), forKey: "Theme")
    }
    
}
