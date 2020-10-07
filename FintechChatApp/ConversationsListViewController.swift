//
//  ConversationsListViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 26.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {

    var dialogs: [ConversationListData.Dialog] = ConversationListData.dialogs
    
    //NavigationBar buttons
    let leftBarButton = UIButton(type: .custom)
    let rightBarButton = UIButton(type: .custom)
    
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
        setupNavigationController()
        filterDialogs(dialogs: &self.dialogs)
        view.addSubview(tableView)
    }
    
    //Func of left navigationBarItem.
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
    
    //Func of right navigationBarItem.
    @objc func openProfile() {
        guard let profileViewController = ProfileViewController.storyboardInstance() else { return }
        self.present(profileViewController, animated: true)
    }
    
    //Filtering data (delete elements isOnline == false and Empty or nil message.
    func filterDialogs(dialogs: inout [ConversationListData.Dialog]) {
      for (index, dialog) in dialogs.enumerated() {
        dialogs[index].dialogInfo = dialog.dialogInfo.filter({ dialog.isOnline || !($0.message?.isEmpty ?? true) })
      }
    }
    
    //NavigationBar Setup.
    func setupNavigationController() {
        
        //Left navigationBarItem.
        leftBarButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        leftBarButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        leftBarButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        leftBarButton.setImage(UIImage(named: "settingsDay"), for: .normal)
        leftBarButton.addTarget(self, action:#selector(openSettings), for: .touchUpInside)
        let barLeftButton = UIBarButtonItem(customView: leftBarButton)
        self.navigationItem.leftBarButtonItems = [barLeftButton]
        
        //Right navigationBarItem.
        rightBarButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        rightBarButton.layer.cornerRadius = rightBarButton.bounds.height/2
        rightBarButton.clipsToBounds = true
        rightBarButton.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        rightBarButton.layer.borderWidth = 1
        rightBarButton.layer.borderColor = #colorLiteral(red: 0.9175510406, green: 0.91209656, blue: 0.9217438698, alpha: 1)
        rightBarButton.setTitle("MD", for: .normal)
        rightBarButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        rightBarButton.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        let barRightButton = UIBarButtonItem(customView: rightBarButton)
        self.navigationItem.rightBarButtonItems = [barRightButton]
        
        self.navigationController?.title = "Tinkoff Chat"
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
}

//MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dialogs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs[section].dialogInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dialog = dialogs[indexPath.section]
        let dialogInfo = dialog.dialogInfo[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        cell.configure(with: .init(name: dialogInfo.name, date: dialogInfo.date, message: dialogInfo.message, isOnline: dialog.isOnline, hasUnreadMessages: dialogInfo.hasUnreadMessages))
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if dialogs[section].isOnline {
            return "Online"
        } else if dialogs[section].isOnline == false {
            return "History"
        } else {
            return ""
        }
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
        conversationViewController.navigationItem.title = dialogs[indexPath.section].dialogInfo[indexPath.row].name
        
        //Checking last message.
        //Checking for nil.
        guard let lastMessage = dialogs[indexPath.section].dialogInfo[indexPath.row].message else {
            self.navigationController?.pushViewController(conversationViewController, animated: true)
            return
        }
        
        //Checking for empty.
        if lastMessage.isEmpty {
            
        } else {
            conversationViewController.lastMessage = .init(text: lastMessage, isOutgoingMessage: false)
        }
        
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
            leftBarButton.setImage(UIImage(named: "settingsDay"), for: .normal)
            
        case .day:
            
            //NavigationBar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (small)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //small title color ++
            
            tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (large)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black] //large title color ++
            
            //Settings Button Image
            leftBarButton.setImage(UIImage(named: "settingsDay"), for: .normal)
            
        case .night:
            
            //NavigationBar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) //change navigation bar color (small)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //small title color
            
            tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) //change navigation bar color (large)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white] //large title color
            
            //Settings Button Image
            leftBarButton.setImage(UIImage(named: "settingsNight"), for: .normal)
            
        }
    }
    
}
