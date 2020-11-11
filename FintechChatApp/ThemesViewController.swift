//
//  ThemesViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 05.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

// В моем случае я реализовал связь ConversationListViewConstroller и ThemesViewController
// Хоть я и использую weak в объявлении переменной делагата и [weak self] в closure во ConversationListVC,
// но по факту мне здесь это не нужно.

// А нужно было бы если:
// ConversationListVC имел в себе поле с инициализацией ThemesViewController, что-то типо
// let themesViewController = ThemesViewController.storyboardInstance() as? ThemesViewController
// и через это поле реализовывал клоужер.
// А так инстанс ThemesViewController у меня создается в функции обработчика нажатия кнопки настроек
// И поэтому этот инстанс живет, только пока срабатывает эта функция.

class ThemesViewController: UIViewController, IThemesModelDelegate {
    
    private let presentationAssembly: IPresentationAssembly
    private let model: IThemesModel
    
    init(presentationAssembly: IPresentationAssembly, model: IThemesModel) {
        self.presentationAssembly = presentationAssembly
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var classicButton: UIView!
    @IBOutlet weak var classicImageView: UIImageView!
    @IBOutlet weak var classicLabel: UILabel!
    
    @IBOutlet weak var dayButton: UIView!
    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var nightButton: UIView!
    @IBOutlet weak var nightImageView: UIImageView!
    @IBOutlet weak var nightLabel: UILabel!
    
    var transferThemeWithClosure: ((ThemeManager.Theme) -> Void)?
    weak var themeDelegate: ThemesPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupThemeButtons()
    }
    
    @objc func setClassicTheme() {

        //Transfer Theme to ThemeManager with closure
        self.transferThemeWithClosure?(.classic)
        
        //Transfer Theme to ThemeManager with delegate
        self.themeDelegate?.transferThemeWithDelegate(theme: .classic)
        
        //Change local UI
        changeTheme(with: ThemeManager.shared.getTheme())
        
    }
    
    @objc func setDayTheme() {
        
        //Transfer Theme to ThemeManager with closure
        self.transferThemeWithClosure?(.day)
        
        //Transfer Theme to ThemeManager with delegate
        self.themeDelegate?.transferThemeWithDelegate(theme: .day)
        
        //Change local UI
        changeTheme(with: ThemeManager.shared.getTheme())
        
    }
    
    @objc func setNightTheme() {
        
        //Transfer Theme to ThemeManager with closure
        self.transferThemeWithClosure?(.night)
        
        //Transfer Theme to ThemeManager with delegate
        self.themeDelegate?.transferThemeWithDelegate(theme: .night)
        
        //Change local UI
        changeTheme(with: ThemeManager.shared.getTheme())
    
    }
    
    func setupNavigationBar() {
        //Title.
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
        self.classicButton.layer.cornerRadius = classicButton.bounds.width / 20
        self.classicButton.layer.borderWidth = 2
        self.classicButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.classicImageView.image = UIImage(named: "classicTheme")
        
        //Day Theme
        let tapOnDayLabel = UITapGestureRecognizer(target: self, action: #selector(self.setDayTheme))
        self.dayLabel.addGestureRecognizer(tapOnDayLabel)
        self.dayLabel.isUserInteractionEnabled = true
        let tapOnDayView = UITapGestureRecognizer(target: self, action: #selector(self.setDayTheme))
        self.dayButton.addGestureRecognizer(tapOnDayView)
        self.dayButton.layer.cornerRadius = dayButton.bounds.width / 20
        self.dayButton.layer.borderWidth = 2
        self.dayButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.dayImageView.image = UIImage(named: "dayTheme")
        
        //Night Theme
        let tapOnNightLabel = UITapGestureRecognizer(target: self, action: #selector(self.setNightTheme))
        self.nightLabel.addGestureRecognizer(tapOnNightLabel)
        self.nightLabel.isUserInteractionEnabled = true
        let tapOnNightView = UITapGestureRecognizer(target: self, action: #selector(self.setNightTheme))
        self.nightButton.addGestureRecognizer(tapOnNightView)
        self.nightButton.layer.cornerRadius = nightButton.bounds.width / 20
        self.nightButton.layer.borderWidth = 2
        self.nightButton.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        self.nightImageView.image = UIImage(named: "nightTheme")
        
    }
    
}

// MARK: - ThemeableViewController
extension ThemesViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme()) //Change theme of ViewController
    }
    
    func changeTheme(with theme: ThemeManager.Theme) {
        switch theme {
        case .classic:
            
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
            
        case .day:
            
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
            
        case .night:
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
    
}
