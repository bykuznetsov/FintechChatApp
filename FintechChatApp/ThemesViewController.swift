//
//  ThemesViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 05.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController, IThemesModelDelegate {
    
    //Dependencies
    private var presentationAssembly: IPresentationAssembly?
    private var model: IThemesModel?
    
    @IBOutlet weak var classicButton: UIView!
    @IBOutlet weak var classicImageView: UIImageView!
    @IBOutlet weak var classicLabel: UILabel!
    
    @IBOutlet weak var dayButton: UIView!
    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var nightButton: UIView!
    @IBOutlet weak var nightImageView: UIImageView!
    @IBOutlet weak var nightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureThemeButtons()
    }
    
    func applyDependencies(model: IThemesModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
    }
    
    @objc func setClassicThemeByButton() {
        guard let model = self.model else { return }
        model.setTheme(new: .classic)
        self.changeTheme(with: model.getTheme())
    }
    
    @objc func setDayThemeByButton() {
        guard let model = self.model else { return }
        model.setTheme(new: .day)
        self.changeTheme(with: model.getTheme())
    }
    
    @objc func setNightThemeByButton() {
        guard let model = self.model else { return }
        model.setTheme(new: .night)
        self.changeTheme(with: model.getTheme())
    }
    
    func configureNavigationBar() {
        //Title.
        self.navigationItem.title = "Settings"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        
        //Back button.
        let backButton = UIBarButtonItem()
        backButton.title = "Chat"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func configureThemeButtons() {
        
        //Classic Theme
        let tapOnClassicLabel = UITapGestureRecognizer(target: self, action: #selector(self.setClassicThemeByButton))
        self.classicLabel.isUserInteractionEnabled = true
        self.classicLabel.addGestureRecognizer(tapOnClassicLabel)
        
        let tapOnClassicView = UITapGestureRecognizer(target: self, action: #selector(self.setClassicThemeByButton))
        self.classicButton.addGestureRecognizer(tapOnClassicView)
        
        //Day Theme
        let tapOnDayLabel = UITapGestureRecognizer(target: self, action: #selector(self.setDayThemeByButton))
        self.dayLabel.addGestureRecognizer(tapOnDayLabel)
        self.dayLabel.isUserInteractionEnabled = true
        let tapOnDayView = UITapGestureRecognizer(target: self, action: #selector(self.setDayThemeByButton))
        self.dayButton.addGestureRecognizer(tapOnDayView)
        
        //Night Theme
        let tapOnNightLabel = UITapGestureRecognizer(target: self, action: #selector(self.setNightThemeByButton))
        self.nightLabel.addGestureRecognizer(tapOnNightLabel)
        self.nightLabel.isUserInteractionEnabled = true
        let tapOnNightView = UITapGestureRecognizer(target: self, action: #selector(self.setNightThemeByButton))
        self.nightButton.addGestureRecognizer(tapOnNightView)
        
    }
    
}

// MARK: - ThemeableViewController
extension ThemesViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let model = model {
            changeTheme(with: model.getTheme())
        }
        //changeTheme(with: ThemeManager.shared.getTheme()) //Change theme of ViewController
    }
    
    func changeTheme(with theme: Theme) {
        switch theme {
        case .classic:
            self.setClassicTheme()
        case .day:
            self.setDayTheme()
        case .night:
            self.setNightTheme()
        }
    }
    
    func setClassicTheme() {
        //Buttons
        self.classicButton.layer.borderWidth = 3.3
        self.classicButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        self.dayButton.layer.borderWidth = 2
        self.dayButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.nightButton.layer.borderWidth = 2
        self.nightButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        //Background
        self.view.backgroundColor = #colorLiteral(red: 0.09803921569, green: 0.2117647059, blue: 0.3803921569, alpha: 1)
        
        //Labels
        self.classicLabel.textColor = .white
        self.dayLabel.textColor = .white
        self.nightLabel.textColor = .white
    }
    
    func setDayTheme() {
        //Buttons
        self.classicButton.layer.borderWidth = 2
        self.classicButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.dayButton.layer.borderWidth = 3.3
        self.dayButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        self.nightButton.layer.borderWidth = 2
        self.nightButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        //Background
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.9365471601, blue: 0.8456528783, alpha: 1)
        
        //Labels
        self.classicLabel.textColor = .black
        self.dayLabel.textColor = .black
        self.nightLabel.textColor = .black
    }
    
    func setNightTheme() {
        //Buttons
        self.classicButton.layer.borderWidth = 2
        self.classicButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.dayButton.layer.borderWidth = 2
        self.dayButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        
        self.nightButton.layer.borderWidth = 3.3
        self.nightButton.layer.borderColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        //Background
        self.view.backgroundColor = .black
        
        //Labels
        self.classicLabel.textColor = .white
        self.dayLabel.textColor = .white
        self.nightLabel.textColor = .white
    }
    
}
