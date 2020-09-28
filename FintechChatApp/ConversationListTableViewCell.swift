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

class ConversationListTableViewCell: UITableViewCell, ConfigurableView {
    
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
        
        //Name
        userName.text = model.name
        userName.font = UIFont.boldSystemFont(ofSize: self.nameFontSize)
        
        //Message
        if model.message == nil { //nil
            textOfLastMessage.text = "No messages yet"
            textOfLastMessage.textColor = .systemGray
            textOfLastMessage.font = UIFont.italicSystemFont(ofSize: self.nameFontSize - 6)
        } else { //not nil
            if model.hasUnreadMessages { //unread
                textOfLastMessage.text = model.message
                textOfLastMessage.textColor = .black
                textOfLastMessage.font = UIFont.boldSystemFont(ofSize: self.nameFontSize - 5)
            } else { //standart
                textOfLastMessage.text = model.message
                textOfLastMessage.textColor = .systemGray
                textOfLastMessage.font = .systemFont(ofSize: self.nameFontSize - 5)
            }
        }
        
        //Date
        let dateFormatter = DateFormatter() // "HH:mm" or "dd MMM"
        
        if model.message != nil { //Last message exist - time of it
            if Calendar.current.isDateInToday(model.date) { //is today
                dateFormatter.dateFormat = "HH:mm"
                dateOfLastMessage.text = dateFormatter.string(from: model.date)
            } else { //not today
                dateFormatter.dateFormat = "dd MMM"
                dateOfLastMessage.text = dateFormatter.string(from: model.date)
            }
        } else { //Last message doesn't exist - time of now
            dateFormatter.dateFormat = "HH:mm"
            dateOfLastMessage.text = dateFormatter.string(from: Date())
        }
        
        //Cell
        if model.isOnline {
            self.backgroundColor = #colorLiteral(red: 1, green: 0.9722861648, blue: 0.9016311765, alpha: 1)
        } else {
            self.backgroundColor = .clear
        }
        
    }
    
}

protocol ConfigurableView {
    
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}




