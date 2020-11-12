//
//  MessageTextField.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class MessageTextField: UITextField {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.returnKeyType = .done
        self.layer.cornerRadius = self.bounds.height / 2
        self.layer.borderColor = UIColor.gray.withAlphaComponent(1).cgColor
        self.layer.borderWidth = 0.7
        self.clipsToBounds = true
        self.attributedPlaceholder = NSAttributedString(string: "Message Text",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])

    }
}
