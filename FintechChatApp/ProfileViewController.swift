//
//  ProfileViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 17.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var saveWithGrandCentralDispatchButton: UIButton!
    @IBOutlet weak var saveWithOperationsButton: UIButton!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileFieldForImage: UIView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileNameTextField: UITextField!
    
    @IBOutlet weak var profileDescriptionTextView: UITextView!
    
    @IBOutlet weak var firstLetterOfNameLabel: UILabel!
    
    let profileDataManager = ProfileDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initProfileInformation()
        setupProfileFieldForImage()
        setupNavigationBar()
        setupSaveButtons()
        setupTextFields()
        addKeyboardNotifications()
        
    }
    
    //Left navigationBarItem.
    @IBAction func editProfile(_ sender: Any?) {
        
        if self.editButton.title == "Edit" { //Switch to Edit mode.
            
            //Name Label
            self.profileNameLabel.isHidden = true
            
            //Name Text Field
            self.profileNameTextField.isEnabled = true
            self.profileNameTextField.isHidden = false
            self.profileNameTextField.text = self.profileNameLabel.text
            self.profileNameTextField.layer.borderWidth = 0.8
            self.profileNameTextField.layer.borderColor = UIColor.gray.cgColor
            
            //Description Text View
            self.profileDescriptionTextView.isEditable = true
            self.profileDescriptionTextView.layer.borderWidth = 0.8
            self.profileDescriptionTextView.layer.borderColor = UIColor.gray.cgColor
            
            //Edit Button
            self.editButton.title = "Done"
            self.editButton.style = .done
            
        } else if self.editButton.title == "Done" { //Switch to Done mode.
            
            //Hide keyboard
            self.view.endEditing(true)
            
            //Case if information changed, but not saved (like "Cancel")
            if isNothingChanged() {
                print("Нет изменений")
            } else {
                alertWithMessageAboutSaving()
                return
            }
            
            //Name Label
            self.profileNameLabel.isHidden = false
            self.profileNameLabel.text = self.profileNameTextField.text

            //Name Text Field
            self.profileNameTextField.isEnabled = false
            self.profileNameTextField.isHidden = true
            
            //Description Text View
            self.profileDescriptionTextView.isEditable = false
            self.profileDescriptionTextView.layer.borderWidth = 0
            
            //Edit Button
            self.editButton.title = "Edit"
            self.editButton.style = .plain
            
            
        }

    }
    
    //Right navigationBarItem.
    @IBAction func closeProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfileWithGrandCentralDispatch(_ sender: Any?) {
        
        if self.profileNameTextField.text != self.profileDataManager.profileName?.name {
            //Update name
            if let name = self.profileNameTextField.text {
                self.profileDataManager.updateProfileName(with: name)
            }
        }
        
        if self.profileDescriptionTextView.text != self.profileDataManager.profileDescription?.description {
            //Update description
            if let description = self.profileDescriptionTextView.text {
                self.profileDataManager.updateProfileDescription(with: description)
            }
        }
        
        self.saveWithGrandCentralDispatchButton.isEnabled = false
        self.saveWithOperationsButton.isEnabled = false
        self.editProfile(nil)
        
    }
    
    @IBAction func saveProfileWithOperations(_ sender: Any) {
        
    }
    
    //Use it if user change something and doesn't save, but press Done Button on NavigationBar
    func alertWithMessageAboutSaving() {
        
        let alert = UIAlertController(title: "Save changes", message: "After making edits", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GCD", style: .default , handler:{ (UIAlertAction) in
            self.saveProfileWithGrandCentralDispatch(nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Operations", style: .default , handler:{ (UIAlertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Don't save", style: .default , handler:{ (UIAlertAction) in
            self.profileNameTextField.text = self.profileDataManager.profileName?.name
            self.profileDescriptionTextView.text = self.profileDataManager.profileDescription?.description
            
            self.saveWithGrandCentralDispatchButton.isEnabled = false
            self.saveWithOperationsButton.isEnabled = false
            
            self.editProfile(nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler:{ (UIAlertAction) in
            
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func editProfileImage(_ sender: Any) {
        selectingImage()
    }
    
    //Use it when typing something in TextField, TextView or when tap on Done button
    func isNothingChanged() -> Bool {
        if self.profileNameTextField.text == self.profileDataManager.profileName?.name && self.profileDescriptionTextView.text == self.profileDataManager.profileDescription?.description {
            return true
        } else {
            return false
        }
    }
    
    //Use it in ViewDidLoad()
    func initProfileInformation() {
        self.profileNameLabel.text = self.profileDataManager.profileName?.name
        self.profileDescriptionTextView.text = self.profileDataManager.profileDescription?.description
    }
    
    //NavigationBar Setup.
    func setupNavigationBar() {
        self.navigationItem.title = "My profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //UI Setups.
    func setupProfileFieldForImage() {
        
        profileFieldForImage.layer.cornerRadius = profileFieldForImage.bounds.height/2
        profileFieldForImage.layer.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        profileFieldForImage.layer.borderWidth = 7
        profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
        
    }
    
    func setupSaveButtons() {
        
        //With GCD
        saveWithGrandCentralDispatchButton.layer.cornerRadius = 14
        saveWithGrandCentralDispatchButton.layer.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        saveWithGrandCentralDispatchButton.isEnabled = false
        
        //With Operations
        saveWithOperationsButton.layer.cornerRadius = 14
        saveWithOperationsButton.layer.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        saveWithOperationsButton.isEnabled = false
    }
    
}

// MARK: -  UITextFieldDelegate, UITextViewDelegate

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func setupTextFields() {
        
        //Profile Name
        self.profileNameTextField.isEnabled = false
        self.profileNameTextField.layer.cornerRadius = 5.0
        self.profileNameTextField.alpha = 1
        self.profileNameTextField.placeholder = "Name"
        self.profileNameTextField.isHidden = true
        self.profileNameTextField.returnKeyType = .done
        self.profileNameTextField.delegate = self
        
        //Profile Description
        self.profileDescriptionTextView.isEditable = false
        self.profileDescriptionTextView.layer.cornerRadius = 5.0
        self.profileDescriptionTextView.alpha = 1
        self.profileDescriptionTextView.returnKeyType = .done
        self.profileDescriptionTextView.delegate = self
        
    }
    
    //Typing something in TextField (after every character)
    @IBAction func inputName(_ sender: UITextField) {
        if isNothingChanged() {
            saveWithGrandCentralDispatchButton.isEnabled = false
            saveWithOperationsButton.isEnabled = false
        } else {
            saveWithGrandCentralDispatchButton.isEnabled = true
            saveWithOperationsButton.isEnabled = true
        }
    }
    
    //Press Done Button in TextField -> dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Typing something in TextView (after every character)
    func textViewDidChange(_ textView: UITextView) {
        if isNothingChanged() {
            saveWithGrandCentralDispatchButton.isEnabled = false
            saveWithOperationsButton.isEnabled = false
        } else {
            saveWithGrandCentralDispatchButton.isEnabled = true
            saveWithOperationsButton.isEnabled = true
        }
    }
    
    //Press Done Button in TextView -> dismiss keyboard
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.view.endEditing(true)
            return false
        }
        else {
            return true
        }
    }
    
    //Moving view.frame if keyboard Show.
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height * 0.7
            }
        }
    }

    //Moving view.frame if keyboard Hide.
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Function which present to us ActionSheet (Alert) with a choice of getting image (From Camera or Photo Album).
    func selectingImage() {
        
        //Initialize UIImagePickerController which will be present in one of two types.
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        //If Camera or Photo Album not available -> show this alert.
        let alertWithNotAvailableMessage = UIAlertController(title: "Attention", message: "This type of image sampling is not available on your device.", preferredStyle: .alert)
        alertWithNotAvailableMessage.addAction(UIAlertAction(title: "Got it", style: .default))
        
        //Setup our ActionSheet
        let actionSheet = UIAlertController(title: "Select image", message: "From one of the options", preferredStyle: .actionSheet)
        
        //Selecting from Camera
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default , handler:{ (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                picker.sourceType = .camera
                self.present(picker, animated: true)
            } else {
                self.present(alertWithNotAvailableMessage, animated: true)
            }
        }))
        //Selecting from Camera
        
        //Selecting from Photo Album.
        actionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default , handler:{ (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true)
            } else {
                self.present(alertWithNotAvailableMessage, animated: true)
            }
        }))
        //Selecting from Photo Album
        
        //Removing photo if it exist
        if profileImageView.image != nil {
            actionSheet.addAction(UIAlertAction(title: "Delete Photo", style: .destructive , handler:{ (UIAlertAction) in
                self.profileImageView.image = nil
            }))
        }
        //Removing photo if it exist
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ (UIAlertAction) in
        }))
        //Setup our ActionSheet
        
        actionSheet.ignoreNegativeWidthConstraints()
        self.present(actionSheet, animated: true)
    }
    
    //Picking image from Photo Album or Camera.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Picking...
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        //Sending image to our UIImageView.
        self.profileImageView.image = image
        picker.dismiss(animated: true)
    }
    
}

//MARK: - ThemeableViewController

extension ProfileViewController: ThemeableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeTheme(with: ThemeManager.shared.getTheme()) //Change theme of ViewController
    }
    
    func changeTheme(with theme: ThemeManager.Theme) {
        switch theme {
            
        case .classic:
            
            //Labels
            profileNameLabel.textColor = .black
            profileNameTextField.textColor = .black
            profileDescriptionTextView.textColor = .black
            
            profileNameTextField.backgroundColor = .white
            profileDescriptionTextView.backgroundColor = .white
            
            //NavigationBar
            self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            
            //Background
            self.view.backgroundColor = .white
            
            //Save Button's
            saveWithGrandCentralDispatchButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            saveWithOperationsButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
            //ProfileFieldForImage
            self.profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
        case .day:
            
            //Labels
            profileNameLabel.textColor = .black
            profileNameTextField.textColor = .black
            profileDescriptionTextView.textColor = .black
            
            profileNameTextField.backgroundColor = .white
            profileDescriptionTextView.backgroundColor = .white
            
            //NavigationBar
            self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
            
            //Background
            self.view.backgroundColor = .white
            
            //Save Button's
            saveWithGrandCentralDispatchButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            saveWithOperationsButton.backgroundColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
            //ProfileFieldForImage
            self.profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
            
        case .night:
            
            //Labels
            profileNameLabel.textColor = .white
            profileNameTextField.textColor = .white
            profileDescriptionTextView.textColor = .white
            
            profileNameTextField.backgroundColor = .black
            profileDescriptionTextView.backgroundColor = .black
            
            //NavigationBar
            self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            
            //Background
            self.view.backgroundColor = .black
            
            //Save Button
            saveWithGrandCentralDispatchButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            saveWithOperationsButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
            //ProfileFieldForImage
            self.profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            
        }
    }
    
}

