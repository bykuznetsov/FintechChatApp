//
//  SaveWithGrandCentralDispatchButton.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class SaveButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 14
        self.layer.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        self.isEnabled = false
        
    }
}
