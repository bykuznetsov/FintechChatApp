//
//  ConversationCell.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 29.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var messageText: UILabel!
    
    @IBOutlet weak var leadingConstaraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    let smallestMessageSpace: CGFloat = 12.0
    
    struct MessageCell {
        let text: String
        let outgoingMessage: Bool
    }
    
    func configure(with model: MessageCell) {
        messageText.text = model.text
        
        if model.outgoingMessage { //Outgoing message
            self.leadingConstaraint.constant = self.frame.width / 4 + self.smallestMessageSpace
            self.trailingConstraint.constant = self.smallestMessageSpace
            self.messageText.textAlignment = .right
            
        } else { //Incoming message
            self.leadingConstaraint.constant = self.smallestMessageSpace
            self.trailingConstraint.constant = self.frame.width / 4 + self.smallestMessageSpace
            self.messageText.textAlignment = .left
            
        }
        
        configureTheme(with: ThemeManager.shared.getTheme(), with: model)
        
    }
}

//MARK: - ThemeableCell

extension ConversationCell: ThemeableCell {
    
    func configureTheme(with theme: ThemeManager.Theme, with model: MessageCell) {
        switch theme {
        case .classic:
            
            messageText.textColor = .black
            
            if model.outgoingMessage {
                self.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            }
        case .day:
            
            messageText.textColor = .black
            
            if model.outgoingMessage {
                self.backgroundColor = #colorLiteral(red: 0.5572292805, green: 0.7642048001, blue: 0.9803817868, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            }
        case .night:
            
            messageText.textColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
            if model.outgoingMessage {
                self.backgroundColor = #colorLiteral(red: 0.5722504258, green: 0.5688518286, blue: 0.574864924, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
}
