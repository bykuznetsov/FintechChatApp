//
//  ConversationsListViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 26.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationsListViewController: UIViewController {
    
    //Test data
    let dialogs: [Dialog] = [
        Dialog(isOnline: true,
               dialogInfo: [
            DialogInfo(name: "Kirill Kurochckin", date: Date(timeIntervalSince1970: 601296841), message: "Hello, bro!", hasUnreadMessages: true),
            DialogInfo(name: "Dmitry Voronin", date: Date(timeIntervalSince1970: 1601296841), message: "Tommorow we will go to cinema", hasUnreadMessages: false),
            DialogInfo(name: "Anton Mosienko", date: Date(timeIntervalSince1970: 1600296841), message: nil, hasUnreadMessages: true),
            DialogInfo(name: "Pomella Anderson", date: Date(timeIntervalSince1970: 16016841), message: "Do you want to join at our party this weekend?", hasUnreadMessages: false),
            DialogInfo(name: "Max Afanas'ev", date: Date(timeIntervalSince1970: 1301296841), message: "How are you?", hasUnreadMessages: true),
            DialogInfo(name: "Mrs Smith", date: Date(timeIntervalSince1970: 62323940), message: "I miss you...", hasUnreadMessages: true)
        ]),

        Dialog(isOnline: false,
               dialogInfo: [
            DialogInfo(name: "Denis Harlamov", date: Date(timeIntervalSince1970: 42323940), message: nil, hasUnreadMessages: false),
            DialogInfo(name: "Artem Voloshin", date: Date(timeIntervalSince1970: 62323940), message: "I need your help! Our grandfather bought a new car without wheels, can you borrow to me your wheels?", hasUnreadMessages: false),
            DialogInfo(name: "Project Alice", date: Date(timeIntervalSince1970: 62323940), message: "Corporation Umbrella again doing evil", hasUnreadMessages: false),
            DialogInfo(name: "Yuri Dud'", date: Date(timeIntervalSince1970: 62323940), message: "I want to take interview with you. Will you be free at next Friday?", hasUnreadMessages: false),
            DialogInfo(name: "Lays", date: Date(timeIntervalSince1970: 62323940), message: "Find promocodes in our products and win prizes!", hasUnreadMessages: false),
            DialogInfo(name: "Grandfather", date: Date(timeIntervalSince1970: 62323940), message: "I found 1 wheel in neighbour house, we need 3 more :)", hasUnreadMessages: false),
            DialogInfo(name: "Neighbour", date: Date(timeIntervalSince1970: 62323940), message: "Give me back my wheel", hasUnreadMessages: false)
        ])
    ]
    
    //Model of test data
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
    
    private let cellIdentifier = String(describing: ConversationListCell.self)
    
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
        view.addSubview(tableView)
    }
    
    @IBAction func openSettings(_ sender: Any) {}
    
    @IBAction func openProfile(_ sender: Any) {
        guard let profileViewController = ProfileViewController.storyboardInstance() else { return }
        self.present(profileViewController, animated: true)
    }
    
    
    func setupNavigationController() {
        self.navigationController?.title = "Tinkoff Chat"
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        if dialogs[section].isOnline == true {
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
        guard let conversationViewController = ConversationViewController.storyboardInstance() else { return }
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }
}
