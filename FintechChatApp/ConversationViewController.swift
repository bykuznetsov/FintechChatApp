//
//  ConversationViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 28.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    var messages: [ConversationData.MessageModel] = ConversationData.messages
    
    //Cell Identifier (ConversationCell).
    private let cellIdentifier = String(describing: ConversationCell.self)
    
    //Create and setup tableView.
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.frame, style: .plain)
        tableView.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    //Get it from ConversationsListViewController.
    var lastMessage: ConversationData.MessageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
        setupMessageHistory(lastMessage: self.lastMessage)
    }
    
    //Consider 2 cases (if lastMessage is Empty or == nil)
    func setupMessageHistory(lastMessage: ConversationData.MessageModel?) {
        
        guard let message = lastMessage else {
            //If we not have last message -> we not have message history.
            self.messages.removeAll()
            self.tableView.tableFooterView = UIView()
            return
        }
        //If we have last message -> we have message history.
        self.messages.append(message)
        
        //Scroll to the bottom of tableView.
        DispatchQueue.main.async {
            self.tableView.scrollRectToVisible(CGRect.init(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height), animated: false)
        }
    }
    
    //NavigationBar Setup.
    func setupNavigationBar() {
        //Title.
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Back button.
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
}

//MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell else {return UITableViewCell()}
        cell.configure(with: .init(text: message.text, isOutgoingMessage: message.isOutgoingMessage))
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - ThemeableViewController

extension ConversationViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme())
        self.tableView.reloadData()
    }
    
    func changeTheme(with theme: ThemeManager.Theme) {
        switch theme {
            
        case .classic:
            
            //Navigation Bar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            self.tableView.backgroundColor = .white
            
        case .day:
            
            //Navigation Bar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            
            self.tableView.backgroundColor = .white
            
        case .night:
            
            //Navigation Bar
            self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            self.tableView.backgroundColor = .black
            
        }
    }
    
}
