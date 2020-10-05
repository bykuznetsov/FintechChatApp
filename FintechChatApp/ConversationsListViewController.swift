//
//  ConversationsListViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 26.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    //You can get time if now in Unix here: https://www.unixtimestamp.com/index.php
    //Test data.
    var dialogs: [Dialog] = [
        Dialog(isOnline: true,
               dialogInfo: [
                DialogInfo(name: "Kirill Kurochckin", date: Date(timeIntervalSince1970: 1601492103), message: "", hasUnreadMessages: true),
                DialogInfo(name: "Dmitry Voronin", date: Date(timeIntervalSince1970: 1601396841), message: "Tommorow we will go to cinema", hasUnreadMessages: false),
                DialogInfo(name: "Garick Markov", date: Date(timeIntervalSince1970: 1600096841), message: "Nice to see you on this platform", hasUnreadMessages: false),
                DialogInfo(name: "Kirill Kurochckin", date: Date(timeIntervalSince1970: 1601492103), message: "", hasUnreadMessages: false),
                DialogInfo(name: "Anton Mosienko", date: Date(timeIntervalSince1970: 1601492103), message: "Do you want to join at our party this weekend?", hasUnreadMessages: true),
                DialogInfo(name: "Pomella Anderson", date: Date(timeIntervalSince1970: 16016841), message: nil, hasUnreadMessages: false),
                DialogInfo(name: "Max Afanas'ev", date: Date(timeIntervalSince1970: 1301296841), message: "How are you?", hasUnreadMessages: true),
                DialogInfo(name: "Mrs Smith", date: Date(timeIntervalSince1970: 1600992103), message: nil, hasUnreadMessages: true)
        ]),
        
        Dialog(isOnline: false,
               dialogInfo: [
                DialogInfo(name: "Denis Harlamov", date: Date(timeIntervalSince1970: 42323940), message: nil, hasUnreadMessages: false),
                DialogInfo(name: "Artem Voloshin", date: Date(timeIntervalSince1970: 1600892103), message: "I need your help! Our grandfather bought a new car without wheels, can you borrow to me your wheels?", hasUnreadMessages: false),
                DialogInfo(name: "Project Alice", date: Date(timeIntervalSince1970: 1600792103), message: "Corporation Umbrella again doing evil", hasUnreadMessages: true),
                DialogInfo(name: "Yuri Dud'", date: Date(timeIntervalSince1970: 1600692103), message: "I want to take interview with you. Will you be free at next Friday?", hasUnreadMessages: false),
                DialogInfo(name: "Leonid Gellert", date: Date(timeIntervalSince1970: 1600092103), message: "", hasUnreadMessages: true),
                DialogInfo(name: "Lays", date: Date(timeIntervalSince1970: 1600592103), message: "Find promocodes in our products and win prizes!", hasUnreadMessages: false),
                DialogInfo(name: "Grandfather", date: Date(timeIntervalSince1970: 1600492103), message: "I found 1 wheel in neighbour house, we need 3 more :)", hasUnreadMessages: false),
                DialogInfo(name: "Sarah Conor", date: Date(timeIntervalSince1970: 1500092103), message: "", hasUnreadMessages: false),
                DialogInfo(name: "Neighbour", date: Date(timeIntervalSince1970: 1600392103), message: "Give me back my wheel", hasUnreadMessages: false),
                DialogInfo(name: "Avatar", date: Date(timeIntervalSince1970: 1600292103), message: nil, hasUnreadMessages: true),
                DialogInfo(name: "Alexandr Markov", date: Date(timeIntervalSince1970: 1600392103), message: "Hola amigo, ¿cómo estás? Me gustaría vernos el próximo fin de semana si no te importa. ¿Cómo estás?", hasUnreadMessages: true),
        ])
    ]
    
    //Model of test data.
    struct Dialog {
        let isOnline: Bool
        var dialogInfo: [DialogInfo]
    }
    
    struct DialogInfo {
        let name: String
        let date: Date
        let message: String?
        let hasUnreadMessages: Bool
    }
    
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
        filterDialogs(dialogs: self.dialogs)
        view.addSubview(tableView)
    }

    //Func of left navigationBarItem.
    @objc func openSettings() {
        guard let themesViewController = ThemesViewController.storyboardInstance() else { return }
        self.navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    //Func of right navigationBarItem.
    @objc func openProfile() {
        guard let profileViewController = ProfileViewController.storyboardInstance() else { return }
        self.present(profileViewController, animated: true)
    }
    
    //Filtering data (delete elements isOnline == false and Empty or nil message.
    func filterDialogs(dialogs: [Dialog]) {
        for i in 0...dialogs.count-1 {
            for j in 0...dialogs[i].dialogInfo.count-1 {
                if dialogs[i].isOnline == false {
                    if dialogs[i].dialogInfo[j].message == "" || dialogs[i].dialogInfo[j].message == nil {
                        self.dialogs[i].dialogInfo.remove(at: j)
                        filterDialogs(dialogs: self.dialogs)
                        return
                    }
                }
            }
        }
    }
    
    //NavigationBar Setup.
    func setupNavigationController() {
        
        //Left navigationBarItem.
        let btnLeft = UIButton(type: UIButton.ButtonType.custom)
        btnLeft.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        btnLeft.widthAnchor.constraint(equalToConstant: 25).isActive = true
        btnLeft.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btnLeft.setImage(UIImage(named: "settings"), for: .normal)
        btnLeft.addTarget(self, action:#selector(openSettings), for: .touchUpInside)
        let barLeftButton = UIBarButtonItem(customView: btnLeft)
        self.navigationItem.leftBarButtonItems = [barLeftButton]
 
        //Right navigationBarItem.
        let btnRight = UIButton(type: .custom)
        btnRight.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        btnRight.layer.cornerRadius = btnRight.bounds.height/2
        btnRight.clipsToBounds = true
        btnRight.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        btnRight.layer.borderWidth = 1
        btnRight.layer.borderColor = #colorLiteral(red: 0.9175510406, green: 0.91209656, blue: 0.9217438698, alpha: 1)
        btnRight.setTitle("MD", for: .normal)
        btnRight.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        btnRight.addTarget(self, action: #selector(openProfile), for: .touchUpInside)
        let barRightButton = UIBarButtonItem(customView: btnRight)
        self.navigationItem.rightBarButtonItems = [barRightButton]
        
        self.navigationController?.title = "Tinkoff Chat"
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell else {return UITableViewCell()}
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110) //Constant size (like in ConversationListTableViewCell.xib)
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
            conversationViewController.lastMessage = .init(text: lastMessage, outgoingMessage: false)
        }
        
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }

}
