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
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var textOfLastMessageLabel: UILabel!
    @IBOutlet weak var dateOfLastMessageLabel: UILabel!
    
    //Model of data which we will get to fill our cell's.
    struct ConversationCellModel {
        let name: String
        let date: Date?
        let message: String?
    }
    
    //All UILabel's depends on this value.
    let nameFontSize: CGFloat = 21.0
    
    func configure(with model: ConversationCellModel) {
        
        //Name.
        userNameLabel.text = model.name
        userNameLabel.font = UIFont.boldSystemFont(ofSize: self.nameFontSize)
        
        //Message
        if (model.message == nil) || model.message == "" { //nil.
            textOfLastMessageLabel.text = "No messages yet"
            textOfLastMessageLabel.textColor = .systemGray
            textOfLastMessageLabel.font = UIFont.italicSystemFont(ofSize: self.nameFontSize - 6)
        } else { //standart.
            textOfLastMessageLabel.text = model.message
            textOfLastMessageLabel.textColor = .systemGray
            textOfLastMessageLabel.font = .systemFont(ofSize: self.nameFontSize - 5)
        }
        
        //Date
        let dateFormatter = DateFormatter() // "HH:mm" or "dd MMM".
        
        if model.message != nil && model.message != "" { //Last message exist - time of it.
            if  Calendar.current.isDateInToday(model.date ?? Date()) { //is today.
                dateFormatter.dateFormat = "HH:mm"
                dateOfLastMessageLabel.text = dateFormatter.string(from: model.date ?? Date())
            } else { //not today.
                dateFormatter.dateFormat = "dd MMM"
                dateOfLastMessageLabel.text = dateFormatter.string(from: model.date ?? Date())
            }
        } else { //Last message doesn't exist - not time.
            dateOfLastMessageLabel.text = ""
        }
        
        configureTheme(with: ThemeManager.shared.getTheme(), with: model)
        
    }
    
}

// MARK: - ThemeableCell

extension ConversationListCell: ThemeableCell {
    
    func configureTheme(with theme: Theme, with model: ConversationCellModel) {
        switch theme {
        case .classic:
            
            self.backgroundColor = .white
            
            self.userNameLabel.textColor = .black
            
            self.dateOfLastMessageLabel.textColor = #colorLiteral(red: 0.7585204244, green: 0.7540128827, blue: 0.7619863153, alpha: 1)
            
        case .day:
            
            self.backgroundColor = .white
            
            self.userNameLabel.textColor = .black
            
            self.dateOfLastMessageLabel.textColor = #colorLiteral(red: 0.7585204244, green: 0.7540128827, blue: 0.7619863153, alpha: 1)
            
        case .night:
            
            self.backgroundColor = .black
            
            self.userNameLabel.textColor = .white
            
            self.dateOfLastMessageLabel.textColor = #colorLiteral(red: 0.7585204244, green: 0.7540128827, blue: 0.7619863153, alpha: 1)
            
        }
    }
    
}
