//
//  ConfigurableView.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 29.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

//This protocol uses in ConversationListTableViewCell.swfit, ConversationViewCell.swift
protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}
