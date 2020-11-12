//
//  ProfileNameTextField.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ProfileNameTextField: UITextField {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.isEnabled = false
        self.layer.cornerRadius = 5.0
        self.alpha = 1
        self.placeholder = "Name"
        self.isHidden = true
        self.returnKeyType = .done
        
    }
}
