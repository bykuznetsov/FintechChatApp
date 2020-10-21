//
//  ConversationCell.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 29.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell, ConfigurableView {
    
    let mySenderId = UIDevice.current.identifierForVendor?.uuidString
    
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    
    @IBOutlet weak var senderNameLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var senderNameTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var createdDateLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var createdDateTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTextLeadingConstaraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextTrailingConstraint: NSLayoutConstraint!
    
    let smallestMessageSpace: CGFloat = 12.0
    
    //New Model
    struct Message {
        let content: String
        let created: Date
        let senderId: String
        let senderName: String
    }
    
    func configure(with model: Message) {
        
        if model.senderId == self.mySenderId {
            senderNameLabel.text = ""
        } else {
            senderNameLabel.text = model.senderName
        }
        senderNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        createdDateLabel.text = dateFormatter.string(from: model.created)
        createdDateLabel.font = .systemFont(ofSize: 10)
        
        messageTextLabel.text = model.content
        messageTextLabel.font = .systemFont(ofSize: 18)
        
        if model.senderId == self.mySenderId { //Outgoing message (Right)
            
            //Sender Name
            self.senderNameLeadingConstraint.constant = self.frame.width / 5 + self.smallestMessageSpace
            self.senderNameTrailingConstraint.constant = self.smallestMessageSpace
            self.senderNameLabel.textAlignment = .right
            
            //Date
            self.createdDateLeadingConstraint.constant = self.smallestMessageSpace
            self.createdDateTrailingConstraint.constant = self.frame.width / 5 + self.smallestMessageSpace
            self.createdDateLabel.textAlignment = .left
            
            //Message Text
            self.messageTextLeadingConstaraint.constant = self.frame.width / 4 + self.smallestMessageSpace
            self.messageTextTrailingConstraint.constant = self.smallestMessageSpace
            self.messageTextLabel.textAlignment = .right
            
        } else { //Incoming message (Left)
            
            //Sender Name
            self.senderNameLeadingConstraint.constant = self.smallestMessageSpace
            self.senderNameTrailingConstraint.constant = self.frame.width / 5 + self.smallestMessageSpace
            self.senderNameLabel.textAlignment = .left
            
            //Date
            self.createdDateLeadingConstraint.constant = self.frame.width / 5 + self.smallestMessageSpace
            self.createdDateTrailingConstraint.constant = self.smallestMessageSpace
            self.createdDateLabel.textAlignment = .right
            
            //Message Text
            self.messageTextLeadingConstaraint.constant = self.smallestMessageSpace
            self.messageTextTrailingConstraint.constant = self.frame.width / 4 + self.smallestMessageSpace
            self.messageTextLabel.textAlignment = .left
            
        }
        
        configureTheme(with: ThemeManager.shared.getTheme(), with: model)
        
    }
}

//MARK: - ThemeableCell

extension ConversationCell: ThemeableCell {
    
    func configureTheme(with theme: ThemeManager.Theme, with model: Message) {
        switch theme {
        case .classic:
            
            senderNameLabel.textColor = .black
            createdDateLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            messageTextLabel.textColor = #colorLiteral(red: 0.1651477218, green: 0.1794092953, blue: 0.1985322237, alpha: 1)
            
            if model.senderId == self.mySenderId {
                self.backgroundColor = #colorLiteral(red: 0.7561650872, green: 0.9217764139, blue: 0.6321023107, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.9638064504, green: 0.9580766559, blue: 0.9682105184, alpha: 1)
            }
            
        case .day:
            
            senderNameLabel.textColor = .black
            createdDateLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            messageTextLabel.textColor = #colorLiteral(red: 0.1651477218, green: 0.1794092953, blue: 0.1985322237, alpha: 1)
            
            if model.senderId == self.mySenderId {
                self.backgroundColor = #colorLiteral(red: 0.574449718, green: 0.7869704366, blue: 1, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.9638064504, green: 0.9580766559, blue: 0.9682105184, alpha: 1)
            }
        case .night:
            
            senderNameLabel.textColor = .white
            createdDateLabel.textColor = #colorLiteral(red: 0.9638064504, green: 0.9580766559, blue: 0.9682105184, alpha: 1)
            messageTextLabel.textColor = #colorLiteral(red: 0.9638064504, green: 0.9580766559, blue: 0.9682105184, alpha: 1)
            
            if model.senderId == self.mySenderId {
                self.backgroundColor = #colorLiteral(red: 0.4815233946, green: 0.4837558866, blue: 0.4891983867, alpha: 1)
            } else {
                self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
    }
}
