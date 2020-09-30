//
//  ConversationViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 28.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ConversationViewController: UIViewController {
    
    //Test data.
    var messages: [MessageModel] = [
        MessageModel(text: "Hello. How are you, my friend?", outgoingMessage: true),
        MessageModel(text: "Hello! I'm fine, what about you?", outgoingMessage: false),
        MessageModel(text: "I got sick :(", outgoingMessage: true),
        MessageModel(text: "Wow, what's happen?", outgoingMessage: false),
        MessageModel(text: "I have headache and stomachache. Tommorow I will need get a package from post office, but I couldn't make it. Can you help me, please?", outgoingMessage: true),
        MessageModel(text: "Ofcourse I will help you. When and where it will be?", outgoingMessage: false),
        MessageModel(text: "2:00 PM on the Red street", outgoingMessage: true),
        MessageModel(text: "Thank you very much", outgoingMessage: true),
        MessageModel(text: "No problem! I hope we will meet in the end of this moth, because 28 of September is the date of my birthday. I want to invite you and your parents!", outgoingMessage: false),
        MessageModel(text: "Oh, ofcourse I accept your invitation. See you soon!", outgoingMessage: true),
    ]
    
    //Model of test data.
    struct MessageModel {
        let text: String
        let outgoingMessage: Bool
    }
    
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
    var lastMessage: MessageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        setupNavigationBar()
        setupMessageHistory(lastMessage: self.lastMessage)
    }
    
    //Consider 2 cases (if lastMessage is Empty or == nil)
    func setupMessageHistory(lastMessage: MessageModel?) {
        
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
        cell.configure(with: .init(text: message.text, outgoingMessage: message.outgoingMessage))
        return cell
    }
    
}

//MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
