//
//  ConversationViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 28.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationViewController: UIViewController, IConversationModelDelegate {
    
//    private let presentationAssembly: IPresentationAssembly
//    private let model: IConversationModel
//    
//    init(presentationAssembly: IPresentationAssembly, model: IConversationModel) {
//        self.presentationAssembly = presentationAssembly
//        self.model = model
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //Cell Identifier (ConversationCell).
    private let cellIdentifier = String(describing: ConversationCell.self)
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    //documentId get from ConversationsListViewController
    lazy var documentId = ""
    
    //Object for working with Firebase (Database)
    lazy var conversationServerManager = ConversationServerManager(documentId: "\(documentId)")
    
    //Object for working with Local Database (data after caching)
    lazy var fetchedResultsController: NSFetchedResultsController<DBMessage> = CoreDataStack.shared.messagesFetchedResultsController(channelId: "\(documentId)")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureMessageTextField()
        configureNavigationBar()
        
        addKeyboardNotifications()
        
        setupFetchedResultsController()
        conversationServerManager.fetchingMessages()
    }
    
    @IBAction func inputMessageText(_ sender: Any) {
        guard let text = messageTextField.text else { return }
        //Check input text (if it empty or only white-spaces - disable sending)
        self.sendButton.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        
        guard let textOfMessage = self.messageTextField.text else { return }
        
        //Personal device ID and name from file
        guard let mySenderId = UIDevice.current.identifierForVendor?.uuidString else { return }
        let senderName = GCDDataManager().initProfileName()
        
        self.conversationServerManager.addNewMessage(message: .init(identifier: "", content: textOfMessage, created: Date(), senderId: mySenderId, senderName: senderName))
        
        self.sendButton.isEnabled = false
        self.messageTextField.text = ""
    }
    
    func setupFetchedResultsController() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        self.fetchedResultsController.delegate = self
    }
    
    //TableView Configure
    func configureTableView() {
        //Flip tableView
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        self.tableView.register(UINib(nibName: String(describing: ConversationCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    //MessageTextView Configure
    func configureMessageTextField() {
        self.messageTextField.delegate = self
    }
    
    //NavigationBar Setup.
    func configureNavigationBar() {
        //Title.
        self.navigationItem.largeTitleDisplayMode = .never
        
        //Back button.
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
    }
    
}

// MARK: - UITableViewDataSource

extension ConversationViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationCell else {return UITableViewCell()}
        
        let message = self.fetchedResultsController.object(at: indexPath)
        
        let content = message.content ?? "Not found"
        let created = message.created ?? Date()
        let senderId = message.senderId ?? "Not found"
        let senderName = message.senderName ?? "Not found"
        
        cell.configure(with: .init(content: content, created: created, senderId: senderId, senderName: senderName))
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension ConversationViewController: UITextFieldDelegate {
    
    //Press Done Button in TextField -> dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                }
            case .move:
                if let indexPath = indexPath, let newIndexPath = newIndexPath {
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                    self.tableView.insertRows(at: [newIndexPath], with: .left)
                }
            case .update:
                if let indexPath = indexPath {
                    self.tableView.reloadRows(at: [indexPath], with: .left)
                }
            case .delete:
                if let indexPath = indexPath {
                    self.tableView.deleteRows(at: [indexPath], with: .left)
                }
            @unknown default:
                print("")
            }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
}

// MARK: - Keyboard

extension ConversationViewController {
    
    //Moving bottomConstraint if keyboard Show.
    @objc func keyboardWillShow(notification: NSNotification) {

        UIView.animate(withDuration: 0.5) {
            
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.bottomConstraint.constant == 0 {
                    self.bottomConstraint.constant -= keyboardSize.height
                }
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    //Moving bottomConstraint if keyboard Hide.
    @objc func keyboardWillHide(notification: NSNotification) {
        
        UIView.animate(withDuration: 0.5) {
            
            if self.bottomConstraint.constant != 0 {
                self.bottomConstraint.constant = 0
            }
            
            self.view.layoutIfNeeded()
        }
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}

// MARK: - ThemeableViewController

extension ConversationViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme())
    }
    
    func changeTheme(with theme: ThemeManager.Theme) {
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
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.view.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
        self.bottomView.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
        
        self.tableView.backgroundColor = .white
        
        //Message TextField
        self.messageTextField.backgroundColor = .white
        self.messageTextField.textColor = .black
    }
    
    func setDayTheme() {
       //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        self.view.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
        self.bottomView.backgroundColor = #colorLiteral(red: 0.9606898427, green: 0.9608504176, blue: 0.9606687427, alpha: 1)
        
        self.tableView.backgroundColor = .white
        
        //Message TextField
        self.messageTextField.backgroundColor = .white
        self.messageTextField.textColor = .black
    }
    
    func setNightTheme() {
        //Navigation Bar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.bottomView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        self.tableView.backgroundColor = .black
        
        //Message TextField
        self.messageTextField.backgroundColor = #colorLiteral(red: 0.3148368597, green: 0.3464637399, blue: 0.3928565383, alpha: 1)
        self.messageTextField.textColor = .white
    }
    
}
