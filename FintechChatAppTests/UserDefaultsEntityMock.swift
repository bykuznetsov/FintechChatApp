//
//  UserDefaultsEntityMock.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 02.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import Foundation

class UserDefaultsEntityMock: IUserDefaultsEntity {
    
    var gettingDefaultsCount: Int = 0
    
    var defaults: UserDefaults {
        gettingDefaultsCount += 1
        return UserDefaults.standard
    }
    
}
