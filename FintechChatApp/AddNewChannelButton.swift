//
//  AddNewChannelButton.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 12.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

class AddNewChannelButton: UIButton {
    required public init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        
        //Configure addNewChannelButton navigationBarItem.
        self.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        self.setTitle("+", for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 32)

    }
}
