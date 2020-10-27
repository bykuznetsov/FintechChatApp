//
//  ProfileViewControllerThemes.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 21.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ThemeableViewController

extension ProfileViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme()) //Change theme of ViewController
    }
    
    func changeTheme(with theme: ThemeManager.Theme) {
        switch theme {
            
        case .classic:
            
            //Labels
            profileNameLabel.textColor = .black
            profileNameTextField.textColor = .black
            profileDescriptionTextView.textColor = .black
            
            profileNameTextField.backgroundColor = .white
            profileDescriptionTextView.backgroundColor = .white
            
            //NavigationBar
            self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            //Background
            self.view.backgroundColor = .white
            
            //Activity Indicator
            self.activityIndicator.color = .gray
            
            //Save Button's
            saveWithGrandCentralDispatchButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            saveWithOperationsButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
            //ProfileFieldForImage
            self.profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
        case .day:
            
            //Labels
            profileNameLabel.textColor = .black
            profileNameTextField.textColor = .black
            profileDescriptionTextView.textColor = .black
            
            profileNameTextField.backgroundColor = .white
            profileDescriptionTextView.backgroundColor = .white
            
            //NavigationBar
            self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            //Background
            self.view.backgroundColor = .white
            
            //Activity Indicator
            self.activityIndicator.color = .gray
            
            //Save Button's
            saveWithGrandCentralDispatchButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            saveWithOperationsButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
            //ProfileFieldForImage
            self.profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
        case .night:
            
            //Labels
            profileNameLabel.textColor = .white
            profileNameTextField.textColor = .white
            profileDescriptionTextView.textColor = .white
            
            profileNameTextField.backgroundColor = .black
            profileDescriptionTextView.backgroundColor = .black
            
            //NavigationBar
            self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            //Background
            self.view.backgroundColor = .black
            
            //Activity Indicator
            self.activityIndicator.color = .white
            
            //Save Button
            saveWithGrandCentralDispatchButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            saveWithOperationsButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
            //ProfileFieldForImage
            self.profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
        }
    }
    
}
