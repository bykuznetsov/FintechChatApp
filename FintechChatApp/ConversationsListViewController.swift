//
//  ConversationsListViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 26.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UIViewController {
    
    //Object for working with Firebase (Database)
    lazy var conversationListServerManager = ConversationListServerManager()

    //NavigationBar buttons
    let settingsButton = UIButton(type: .custom)
    let profileButton = UIButton(type: .custom)
    let addNewChannelButton = UIButton(type: .custom)
    
    let alertWithAddingChannel = UIAlertController(title: "Create channel", message: "Enter name", preferredStyle: .alert)
    
    //Cell Identifier (ConversationListCell).
    private let cellIdentifier = String(describing: ConversationListCell.self)
    
    //Create and setup tableView.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: ConversationListCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationController()
        setupAlertWithAddingChannel()
        
        conversationListServerManager.fetchingChannels(for: self.tableView)
    }
    
    //Func of settingsBarButton.
    @objc func openSettings() {
        guard let themesViewController = ThemesViewController.storyboardInstance() as? ThemesViewController else { return }
        
        //Transfer Theme from closure
        themesViewController.transferThemeWithClosure = { [weak self] theme in
            guard self != nil else { return }
            ThemeManager.shared.updateTheme(new: theme)
            
            print("\(theme) from closure")
        }
        
        //Transfer Theme with delegate
        themesViewController.themeDelegate = self
        
        self.navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    //Func of profileBarButton.
    @objc func openProfile() {
        guard let profileViewController = ProfileViewController.storyboardInstance() else { return }
        self.present(profileViewController, animated: true)
    }
    
    //Func of addNewChannelButton.
    @objc func showAlertWithAddingChannel() {
        DispatchQueue.main.async {
            self.present(self.alertWithAddingChannel, animated: true, completion: nil)
        }
    }
    
    //Func of TextField in alertWithAddingChannel
    @objc func inputChannelName(_ sender: UITextField) {
        guard let text = sender.text else { return }
        //Check input text (if it empty or only white-spaces - disable creating)
        self.alertWithAddingChannel.actions[0].isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func setupAlertWithAddingChannel() {
        
        self.alertWithAddingChannel.addTextField { textField in
            textField.placeholder = "Channel name"
            textField.addTarget(self, action: #selector(self.inputChannelName), for: .editingChanged)
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { (action) in
            
            guard let textFields = self.alertWithAddingChannel.textFields else { return }
            guard let textField = textFields.first else { return }
            guard let text = textField.text else { return }
            
            //text - name of new channel
            self.conversationListServerManager.addNewChannel(channel: .init(identifier: "", name: text, lastMessage: nil, lastActivity: nil))
            
            action.isEnabled = false
            textField.text = ""
        })
        createAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            guard let textFields = self.alertWithAddingChannel.textFields else { return }
            guard let textField = textFields.first else { return }
            
            createAction.isEnabled = false
            textField.text = ""
        })
        
        self.alertWithAddingChannel.addAction(createAction)
        self.alertWithAddingChannel.addAction(cancelAction)
    }
    
    //NavigationBar Setup.
    func setupNavigationController() {
        
        //Configure settingsBarButton navigationBarItem.
        settingsButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        settingsButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        settingsButton.setImage(UIImage(named: "settingsDay"), for: .normal)
        settingsButton.addTarget(self, action:#selector(openSettings), for: .touchUpInside)
        let settingsBarButton = UIBarButtonItem(customView: settingsButton)
        
        //Adding to Navigation Bar - settingsBarButton (Leftside)
        self.navigationItem.leftBarButtonItems = [settingsBarButton]
        
        //Configure profileBarButton navigationBarItem.
        profileButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        profileButton.layer.cornerRadius = profileButton.bounds.height/2
        profileButton.clipsToBounds = true
        profileButton.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        profileButton.layer.borderWidth = 1
        profileButton.layer.borderColor = #colorLiteral(red: 0.9175510406, green: 0.91209656, blue: 0.9217438698, alpha: 1)
        profileButton.setTitle("MD", for: .normal)
        profileButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        profileButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        let profileBarButton = UIBarButtonItem(customView: profileButton)
        
        //Configure addNewChannelButton navigationBarItem.
        addNewChannelButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        addNewChannelButton.setTitle("+", for: .normal)
        addNewChannelButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addNewChannelButton.addTarget(self, action: #selector(showAlertWithAddingChannel), for: .touchUpInside)
        let addNewChannelBarButton = UIBarButtonItem(customView: addNewChannelButton)
        
        //Adding to Navigation Bar - profileBarButton, addNewChannelBarButton (Rightside)
        self.navigationItem.rightBarButtonItems = [profileBarButton, addNewChannelBarButton]
        
        self.navigationController?.title = "Channels"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
}

//MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationListServerManager.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let channel = conversationListServerManager.channels[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        cell.configure(with: .init(name: channel.name, date: channel.lastActivity?.dateValue(), message: channel.lastMessage))
        
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Data transfer.
        //Init ConversationViewController.
        guard let conversationViewController = ConversationViewController.storyboardInstance() as? ConversationViewController else { return }
        
        //Change Navigation Bar title to the name of companion.
        conversationViewController.navigationItem.title = conversationListServerManager.channels[indexPath.row].name
        
        conversationViewController.documentId = conversationListServerManager.channels[indexPath.row].identifier
        
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110) //Constant size (like in ConversationListTableViewCell.xib)
    }
    
}

//MARK: - ThemesPickerDelegate

protocol ThemesPickerDelegate: class {
    func transferThemeWithDelegate(theme: ThemeManager.Theme)
}

extension ConversationsListViewController: ThemesPickerDelegate {
    func transferThemeWithDelegate(theme: ThemeManager.Theme) {
//        ThemeManager.shared.updateTheme(new: theme)
//        
//        print("\(theme) from delegate")
    }
}

//MARK: - ThemeableViewController

extension ConversationsListViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme()) //Change theme of ViewController
        self.tableView.reloadData() //Change Theme of TableView
    }
    
    func changeTheme(with theme: ThemeManager.Theme) {
        switch theme {
            
        case .classic:
            
            //NavigationBar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (small)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //small title color
            
            tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (large)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black] //large title color
            
            //Settings Button Image
            settingsButton.setImage(UIImage(named: "settingsDay"), for: .normal)
            
            //Adding channel Button
            addNewChannelButton.setTitleColor(.black, for: .normal)
            addNewChannelButton.setTitleColor(.gray, for: .highlighted)
            
        case .day:
            
            //NavigationBar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (small)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //small title color ++
            
            tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (large)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black] //large title color ++
            
            //Settings Button Image
            settingsButton.setImage(UIImage(named: "settingsDay"), for: .normal)
            
            //Adding channel Button
            addNewChannelButton.setTitleColor(.black, for: .normal)
            addNewChannelButton.setTitleColor(.gray, for: .highlighted)
            
        case .night:
            
            //NavigationBar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) //change navigation bar color (small)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //small title color
            
            tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) //change navigation bar color (large)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white] //large title color
            
            //Settings Button Image
            settingsButton.setImage(UIImage(named: "settingsNight"), for: .normal)
            
            //Adding channel Button
            addNewChannelButton.setTitleColor(.white, for: .normal)
            addNewChannelButton.setTitleColor(.gray, for: .highlighted)
            
        }
    }
    
}
