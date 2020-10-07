//
//  ConversationListTableViewCell.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 26.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//
//

import Foundation
import UIKit

class ConversationListCell: UITableViewCell, ConfigurableView {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var textOfLastMessage: UILabel!
    @IBOutlet weak var dateOfLastMessage: UILabel!
    
    //Model of data which we will get to fill our cell's.
    struct ConversationCellModel {
        let name: String
        let date: Date
        let message: String?
        let isOnline: Bool
        let hasUnreadMessages: Bool
    }
    
    //All UILabel's depends on this value.
    let nameFontSize: CGFloat = 21.0
    
    func configure(with model: ConversationCellModel) {
        
        //Name.
        userName.text = model.name
        userName.font = UIFont.boldSystemFont(ofSize: self.nameFontSize)
        
        //Message
        if (model.message == nil) || model.message == "" { //nil.
            textOfLastMessage.text = "No messages yet"
            textOfLastMessage.textColor = .systemGray
            textOfLastMessage.font = UIFont.italicSystemFont(ofSize: self.nameFontSize - 6)
        } else { //not nil.
            if model.hasUnreadMessages { //unread.
                textOfLastMessage.text = model.message
                textOfLastMessage.textColor = .black
                textOfLastMessage.font = UIFont.boldSystemFont(ofSize: self.nameFontSize - 5)
            } else { //standart.
                textOfLastMessage.text = model.message
                textOfLastMessage.textColor = .systemGray
                textOfLastMessage.font = .systemFont(ofSize: self.nameFontSize - 5)
            }
        }
        
        //Date
        let dateFormatter = DateFormatter() // "HH:mm" or "dd MMM".
        
        if model.message != nil && model.message != "" { //Last message exist - time of it.
            if Calendar.current.isDateInToday(model.date) { //is today.
                dateFormatter.dateFormat = "HH:mm"
                dateOfLastMessage.text = dateFormatter.string(from: model.date)
            } else { //not today.
                dateFormatter.dateFormat = "dd MMM"
                dateOfLastMessage.text = dateFormatter.string(from: model.date)
            }
        } else { //Last message doesn't exist - not time.
            dateOfLastMessage.text = ""
        }
        
        //Cell.
        if model.isOnline {
            self.backgroundColor = #colorLiteral(red: 1, green: 0.9722861648, blue: 0.9016311765, alpha: 1)
        } else {
            self.backgroundColor = .white
        }
        
        configureTheme(with: ThemeManager.shared.getTheme(), with: model)
        
    }
    
}

//MARK: - ThemeableCell

extension ConversationListCell: ThemeableCell {
    
    func configureTheme(with theme: ThemeManager.Theme, with model: ConversationCellModel) {
        switch theme {
        case .classic:
            
            if model.isOnline {
                self.backgroundColor = #colorLiteral(red: 1, green: 0.9722861648, blue: 0.9016311765, alpha: 1)
            } else {
                self.backgroundColor = .white
            }
            
            self.userName.textColor = .black
            
            if (model.message == nil) || model.message == "" { //nil.
                
            } else if model.hasUnreadMessages {
                self.textOfLastMessage.textColor = .black
            }
            
            self.dateOfLastMessage.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        case .day:
            
            if model.isOnline {
                self.backgroundColor = #colorLiteral(red: 1, green: 0.9722861648, blue: 0.9016311765, alpha: 1)
            } else {
                self.backgroundColor = .white
            }
            
            self.userName.textColor = .black
            
            
            if (model.message == nil) || model.message == "" {
            
            } else if model.hasUnreadMessages {
                self.textOfLastMessage.textColor = .black
            }
            
            self.dateOfLastMessage.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        case .night:
            
            if model.isOnline {
                self.backgroundColor = #colorLiteral(red: 0.1824742258, green: 0.1982340217, blue: 0.2193621099, alpha: 1)
            } else {
                self.backgroundColor = .black
            }
            
            self.userName.textColor = .white
            
            if (model.message == nil) || model.message == "" {
                
            } else if model.hasUnreadMessages {
                self.textOfLastMessage.textColor = .white
            }
            
            self.dateOfLastMessage.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            
        }
    }
    
}
