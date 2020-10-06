//
//  ThemesViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 05.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    @IBOutlet weak var classicButton: UIView!
    @IBOutlet weak var classicImageView: UIImageView!
    @IBOutlet weak var classicLabel: UILabel!
    
    @IBOutlet weak var dayButton: UIView!
    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var nightButton: UIView!
    @IBOutlet weak var nightImageView: UIImageView!
    @IBOutlet weak var nightLabel: UILabel!
    
    enum Theme {
        case classic
        case day
        case night
    }
    
    var localTheme: Theme = .classic
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupThemeButtons()
        changeLocalTheme(localTheme: self.localTheme)
    }
    
    func changeLocalTheme(localTheme: Theme) {
        switch self.localTheme {
        case .classic:
            self.classicButton.layer.borderWidth = 3.3
            self.classicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            
            self.dayButton.layer.borderWidth = 2
            self.dayButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            self.nightButton.layer.borderWidth = 2
            self.nightButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
        case .day:
            self.classicButton.layer.borderWidth = 2
            self.classicButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            self.dayButton.layer.borderWidth = 3.3
            self.dayButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            
            self.nightButton.layer.borderWidth = 2
            self.nightButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
        case .night:
            self.classicButton.layer.borderWidth = 2
            self.classicButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            self.dayButton.layer.borderWidth = 2
            self.dayButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            self.nightButton.layer.borderWidth = 3.3
            self.nightButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        }
    }
    
    @objc func setClassicTheme() {
        //Change local UI
        self.localTheme = .classic
        changeLocalTheme(localTheme: self.localTheme)
        
        //Change general settings...
    }
    
    @objc func setDayTheme() {
        //Change local UI
        self.localTheme = .day
        changeLocalTheme(localTheme: self.localTheme)
        
        //Change general settings...
    }
    
    @objc func setNightTheme() {
        //Change local UI
        self.localTheme = .night
        changeLocalTheme(localTheme: self.localTheme)
        
        //Change general settings...
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
    
    func setupThemeButtons() {
        
        //Classic Theme
        let tapOnClassicLabel = UITapGestureRecognizer(target: self, action: #selector(self.setClassicTheme))
        self.classicLabel.isUserInteractionEnabled = true
        self.classicLabel.addGestureRecognizer(tapOnClassicLabel)
        let tapOnClassicView = UITapGestureRecognizer(target: self, action: #selector(self.setClassicTheme))
        self.classicButton.addGestureRecognizer(tapOnClassicView)
        self.classicButton.layer.cornerRadius = classicButton.bounds.width/20
        self.classicButton.layer.borderWidth = 2
        self.classicButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.classicImageView.image = UIImage(named: "classicTheme")
        
        //Day Theme
        let tapOnDayLabel = UITapGestureRecognizer(target: self, action: #selector(self.setDayTheme))
        self.dayLabel.addGestureRecognizer(tapOnDayLabel)
        self.dayLabel.isUserInteractionEnabled = true
        let tapOnDayView = UITapGestureRecognizer(target: self, action: #selector(self.setDayTheme))
        self.dayButton.addGestureRecognizer(tapOnDayView)
        self.dayButton.layer.cornerRadius = dayButton.bounds.width/20
        self.dayButton.layer.borderWidth = 2
        self.dayButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.dayImageView.image = UIImage(named: "dayTheme")
        
        //Night Theme
        let tapOnNightLabel = UITapGestureRecognizer(target: self, action: #selector(self.setNightTheme))
        self.nightLabel.addGestureRecognizer(tapOnNightLabel)
        self.nightLabel.isUserInteractionEnabled = true
        let tapOnNightView = UITapGestureRecognizer(target: self, action: #selector(self.setNightTheme))
        self.nightButton.addGestureRecognizer(tapOnNightView)
        self.nightButton.layer.cornerRadius = nightButton.bounds.width/20
        self.nightButton.layer.borderWidth = 2
        self.nightButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.nightImageView.image = UIImage(named: "nightTheme")
        
    }

}
