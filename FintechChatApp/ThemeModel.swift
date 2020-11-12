//
//  ThemeModel.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol IThemesModelDelegate: class {
    
}

protocol IThemesModel: class {
    var delegate: IThemesModelDelegate? { get set }
    func getTheme() -> Theme
    func setTheme(new theme: Theme)
}

class ThemesModel: IThemesModel {
    
    var delegate: IThemesModelDelegate?
    
    var themeService: ThemeServiceProtocol
    
    init(themeService: ThemeServiceProtocol) {
        self.themeService = themeService
    }
    
    func getTheme() -> Theme {
        self.themeService.getTheme()
    }
    
    func setTheme(new theme: Theme) {
        self.themeService.setTheme(new: theme)
    }
    
}
