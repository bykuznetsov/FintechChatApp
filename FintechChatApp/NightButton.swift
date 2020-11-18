//
//  NightButton.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class NightButton: UIView {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = self.bounds.width / 20
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
    }
}
