//
//  UserDefaultsEntity.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol UserDefaultsEntityProtocol {
    var defaults: UserDefaults { get }
}

class UserDefaultsEntity: UserDefaultsEntityProtocol {
    var defaults: UserDefaults = UserDefaults.standard
}
