//
//  ProfileButton.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ProfileButton: UIButton {

    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        self.layer.cornerRadius = self.bounds.height / 2
        self.clipsToBounds = true
        self.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.9175510406, green: 0.91209656, blue: 0.9217438698, alpha: 1)
        self.setTitle("N", for: .normal)
        self.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)

    }
    
}
