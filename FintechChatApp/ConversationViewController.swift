//
//  ConversationViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 28.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UIViewController {
    
    //documentId get from ConversationsListViewController
    lazy var documentId = ""
    
    //Object for working with Firebase (Database)
    lazy var conversationServerManager = ConversationServerManager(documentId: "\(documentId)")
    
    //Plus button on Navigation Bar
    let addNewMessageButton = UIButton(type: .custom)
    
    let alertWithAddingMessage = UIAlertController(title: "Send Message", message: "Enter text", preferredStyle: .alert)
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
        setupAlertWithAddingMessage()
        
        conversationServerManager.fetchingMessages(for: self.tableView)
    }
    
    @objc func showAlertWithAddingMessage() {
        DispatchQueue.main.async {
            self.present(self.alertWithAddingMessage, animated: true, completion: nil)
        }
    }
    
    //Func of TextField in alertWithAddingMessage
    @objc func inputMessageText(_ sender: UITextField) {
        guard let text = sender.text else { return }
        //Check input text (if it empty or only white-spaces - disable sending)
        self.alertWithAddingMessage.actions[0].isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    func setupAlertWithAddingMessage() {
        
        self.alertWithAddingMessage.addTextField { textField in
            textField.placeholder = "Message"
            textField.addTarget(self, action: #selector(self.inputMessageText), for: .editingChanged)
        }
        
        let createAction = UIAlertAction(title: "Send", style: .default, handler: { [weak self] (action) in
            
            guard let textFields = self?.alertWithAddingMessage.textFields else { return }
            guard let textField = textFields.first else { return }
            guard let text = textField.text else { return }
            
            //Personal device ID and name from file
            guard let mySenderId = UIDevice.current.identifierForVendor?.uuidString else { return }
            let senderName = GCDDataManager().initProfileName()
            
            //text - text of message
            self?.conversationServerManager.addNewMessage(message: .init(identifier: "", content: text, created: Date(), senderId: mySenderId, senderName: senderName))
            
            action.isEnabled = false
            textField.text = ""
            
        })
        createAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (_) in
            
            guard let textFields = self?.alertWithAddingMessage.textFields else { return }
            guard let textField = textFields.first else { return }
            
            createAction.isEnabled = false
            textField.text = ""
            
        })
        
        self.alertWithAddingMessage.addAction(createAction)
        self.alertWithAddingMessage.addAction(cancelAction)
        
    }
    
    //NavigationBar Setup.
    func setupNavigationBar() {
        //Title.
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Back button.
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        //Configure addNewMessageButton navigationBarItem.
        addNewMessageButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        addNewMessageButton.setTitle("+", for: .normal)
        addNewMessageButton.setTitleColor(.systemBlue, for: .normal)
        addNewMessageButton.setTitleColor(.gray, for: .highlighted)
        addNewMessageButton.titleLabel?.font = UIFont.systemFont(ofSize: 32)
        addNewMessageButton.addTarget(self, action: #selector(showAlertWithAddingMessage), for: .touchUpInside)
        let addNewMessageBarButton = UIBarButtonItem(customView: addNewMessageButton)
        
        //Adding to Navigation Bar - profileBarButton, addNewChannelBarButton (Rightside)
        self.navigationItem.rightBarButtonItems = [addNewMessageBarButton]
        
    }
    
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationServerManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell else {return UITableViewCell()}
        
        let message = conversationServerManager.messages[indexPath.row]
        
        cell.configure(with: .init(content: message.content, created: message.created, senderId: message.senderId, senderName: message.senderName))
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - ThemeableViewController

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
