//
//  ConversationsListViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 26.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UIViewController, IConversationListModelDelegate {
    
//    private let presentationAssembly: IPresentationAssembly
//    private let model: IConversationListModel
//    
//    init(presentationAssembly: IPresentationAssembly, model: IConversationListModel) {
//        self.presentationAssembly = presentationAssembly
//        self.model = model
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    //Cell Identifier (ConversationListCell).
    private let cellIdentifier = String(describing: ConversationListCell.self)
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var settingsButton: SettingsButton!
    @IBOutlet weak var addNewChannelButton: AddNewChannelButton!
    @IBOutlet weak var profileButton: ProfileButton!
    
    //Object for working with Firebase (Database)
    lazy var conversationListServerManager = ConversationListServerManager()
    
    //Object for working with Local Database (data after caching)
    lazy var fetchedResultsController: NSFetchedResultsController<DBChannel> = CoreDataStack.shared.channelsFetchedResultsController
    
    let alertWithAddingChannel = UIAlertController(title: "Create channel", message: "Enter name", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        configureAlertWithAddingChannel()
        
        configureFetchedResultsController()
        conversationListServerManager.fetchingChannels()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: ConversationListCell.self), bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    
    //Func of settingsBarButton.
    @IBAction func openSettings(_ sender: Any) {
        guard let themesViewController = ThemesViewController.storyboardInstance() as? ThemesViewController else { return }
        
        //Transfer Theme from closure
        themesViewController.transferThemeWithClosure = { [weak self] theme in
            guard self != nil else { return }
            ThemeManager.shared.updateTheme(new: theme)
            
        }
        
        self.navigationController?.pushViewController(themesViewController, animated: true)
    }
    
    //Func of profileBarButton.
    @IBAction func openProfile(_ sender: Any) {
        guard let profileViewController = ProfileViewController.storyboardInstance() else { return }
        self.present(profileViewController, animated: true)
    }
    
    //Func of addNewChannelButton.
    @IBAction func showAlertWithAddingChannel(_ sender: Any) {
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
    
    func configureFetchedResultsController() {
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
        
        self.fetchedResultsController.delegate = self
    }
    
    func configureAlertWithAddingChannel() {
        
        self.alertWithAddingChannel.addTextField { textField in
            textField.placeholder = "Channel name"
            textField.addTarget(self, action: #selector(self.inputChannelName), for: .editingChanged)
        }
        
        let createAction = UIAlertAction(title: "Create", style: .default, handler: { [weak self] (action) in
            
            guard let textFields = self?.alertWithAddingChannel.textFields else { return }
            guard let textField = textFields.first else { return }
            guard let text = textField.text else { return }
            
            //text - name of new channel
            self?.conversationListServerManager.addNewChannel(channel: .init(identifier: "", name: text, lastMessage: nil, lastActivity: nil))
            
            action.isEnabled = false
            textField.text = ""
        })
        createAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (_) in
            guard let textFields = self?.alertWithAddingChannel.textFields else { return }
            guard let textField = textFields.first else { return }
            
            createAction.isEnabled = false
            textField.text = ""
        })
        
        self.alertWithAddingChannel.addAction(createAction)
        self.alertWithAddingChannel.addAction(cancelAction)
    }
    
// MARK: - IConversationListModelDelegate
        
}

// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
    
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
        let channel = self.fetchedResultsController.object(at: indexPath)
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationListCell else { return UITableViewCell() }
        
        cell.configure(with: .init(name: channel.name ?? "Not found", date: channel.lastActivity, message: channel.lastMessage))
        
        return cell
    }
    
    //Delete cell by swipe
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let identifier = fetchedResultsController.object(at: indexPath).identifier else { return }
            self.conversationListServerManager.deleteChannel(at: identifier)
        }
    }
    
}

// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //Data transfer.
        //Init ConversationViewController.
        guard let conversationViewController = ConversationViewController.storyboardInstance() as? ConversationViewController else { return }
        
        //Change Navigation Bar title to the name of companion.
        conversationViewController.navigationItem.title = fetchedResultsController.object(at: indexPath).name
        
        if let identifier = fetchedResultsController.object(at: indexPath).identifier {
            conversationViewController.documentId = identifier
        }
       
        self.navigationController?.pushViewController(conversationViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(110) //Constant size (like in ConversationListTableViewCell.xib)
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?) {
        
        guard self.isViewLoaded, self.view.window != nil else { return }
        
            switch type {
            case .insert:
                if let newIndexPath = newIndexPath {
                    self.tableView.insertRows(at: [newIndexPath], with: .left)
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
        guard self.isViewLoaded, self.view.window != nil else { return }
        
        self.tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard self.isViewLoaded, self.view.window != nil else { return }
        
        self.tableView.endUpdates()
    }
    
}

// MARK: - ThemeableViewController

extension ConversationsListViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme()) //Change theme of ViewController
        self.tableView.reloadData() //Change Theme of TableView
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
        //NavigationBar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (small)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //small title color
        
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (large)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //large title color
        
        //Settings Button Image
        settingsButton.setImage(UIImage(named: "settingsDay"), for: .normal)
        
        //Adding channel Button
        addNewChannelButton.setTitleColor(.black, for: .normal)
        addNewChannelButton.setTitleColor(.gray, for: .highlighted)
    }
    
    func setDayTheme() {
        //NavigationBar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (small)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //small title color ++
        
        tableView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1) //change navigation bar color (large)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] //large title color ++
        
        //Settings Button Image
        settingsButton.setImage(UIImage(named: "settingsDay"), for: .normal)
        
        //Adding channel Button
        addNewChannelButton.setTitleColor(.black, for: .normal)
        addNewChannelButton.setTitleColor(.gray, for: .highlighted)
    }
    
    func setNightTheme() {
        //NavigationBar
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) //change navigation bar color (small)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //small title color
        
        tableView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1) //change navigation bar color (large)
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] //large title color
        
        //Settings Button Image
        settingsButton.setImage(UIImage(named: "settingsNight"), for: .normal)
        
        //Adding channel Button
        addNewChannelButton.setTitleColor(.white, for: .normal)
        addNewChannelButton.setTitleColor(.gray, for: .highlighted)
    }
    
}
