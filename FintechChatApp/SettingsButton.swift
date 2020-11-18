//
//  SettingsButton.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class SettingsButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)

        self.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.heightAnchor.constraint(equalToConstant: 25).isActive = true
        self.setImage(UIImage(named: "settingsDay"), for: .normal)

    }
}
