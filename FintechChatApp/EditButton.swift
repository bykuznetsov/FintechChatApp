//
//  EditButton.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 25.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class EditButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        self.widthAnchor.constraint(equalToConstant: 45).isActive = true
        self.setTitle("Edit", for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 16.5, weight: .regular)
    }
}

extension EditButton {
    open override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
}
