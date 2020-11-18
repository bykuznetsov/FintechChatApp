//
//  ProfileFieldForImage.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ProfileFieldForImage: UIView {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        self.layer.borderWidth = 7
        self.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)

    }
}
