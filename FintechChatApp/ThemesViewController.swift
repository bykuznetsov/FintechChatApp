//
//  ThemesViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 05.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        //Title
        self.navigationItem.title = "Settings"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        //Back button.
        let backButton = UIBarButtonItem()
        backButton.title = "Chat"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

}
