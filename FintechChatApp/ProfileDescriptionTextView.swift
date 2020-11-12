//
//  ProfileDescriptionTextView.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class ProfileDescriptionTextView: UITextView {
    required public init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        self.isEditable = false
        self.layer.cornerRadius = 5.0
        self.alpha = 1
        self.returnKeyType = .done
        
    }
}
