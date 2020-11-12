//
//  ThemeableView.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 07.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

// MARK: When implementing this protocol you should only change the colors of your views.

//This protocol uses in ViewController's with 3 types theme: .classic, .day, .night
//Method changeTheme(with theme:) uses in viewWillAppear

protocol ThemeableViewController {
    
    func changeTheme(with theme: ThemeManager.Theme)
    
    func setClassicTheme()
    func setDayTheme()
    func setNightTheme()
    
}

//This protocol uses in TableViewCell's with 3 types theme: .classic, .day, .night
//Method configureTheme(with theme:) uses in configure(with model:)

protocol ThemeableCell {
    
    associatedtype ConfigurationModel
    
    func configureTheme(with theme: ThemeManager.Theme, with model: ConfigurationModel)
    
}
