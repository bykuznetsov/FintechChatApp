//
//  ProfileViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 17.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, IProfileModelDelegate {
    
    private var presentationAssembly: IPresentationAssembly?
    private var model: IProfileModel?
    
    @IBOutlet weak var saveWithGrandCentralDispatchButton: UIButton!
    @IBOutlet weak var saveWithOperationsButton: UIButton!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileFieldForImage: UIView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileInitialsLabel: UILabel!
    
    @IBOutlet weak var profileDescriptionTextView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let profileDataManager = GCDDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initProfileInformation()
        setupNavigationBar()
        configureTextFields()
        addKeyboardNotifications()
        configureActivityIndicator()
    }
    
    func applyDependencies(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
    }
    
    func configureTextFields() {
        self.profileNameTextField.delegate = self
        self.profileDescriptionTextView.delegate = self
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
            
            //Case if text (name or description) information changed, but not saved (like "Cancel")
            if isNothingInTextsChanged() {
                
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
            
            //Initials
            if let initials = self.profileNameTextField.text?.first {
                self.profileInitialsLabel.text = String(describing: initials)
            } else {
                self.profileInitialsLabel.text = ""
            }
            
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
        self.activityIndicator.startAnimating()
        
        let grandCentralDispatchDataManager = GCDDataManager()
    
        self.saveWithGrandCentralDispatchButton.isEnabled = false
        self.saveWithOperationsButton.isEnabled = false
        
        if self.profileNameTextField.text != grandCentralDispatchDataManager.profileName {
            //Update name
            print("Update name")
            if let name = self.profileNameTextField.text {
                grandCentralDispatchDataManager.updateProfileName(with: name)
            }
        }
        
        if self.profileDescriptionTextView.text != grandCentralDispatchDataManager.profileDescription?.description {
            //Update description
            print("Update description")
            if let description = self.profileDescriptionTextView.text {
                grandCentralDispatchDataManager.updateProfileDescription(with: description)
            }
        }
        
        if self.profileImageView.image?.pngData() != grandCentralDispatchDataManager.profileImage?.pngData() {
            //Update image
            print("Update image")
            if let image = self.profileImageView.image {
                grandCentralDispatchDataManager.updateProfileImage(with: image)
            }
        }
        
        grandCentralDispatchDataManager.returnToMainQueue {
            self.activityIndicator.stopAnimating()
            
            //Out of editing mode if we saving data (case when we change image)
            if self.editButton.title != "Edit" {
                
                //func of our EditButton
                self.editProfile(nil)
                
            }
            
            if self.isAllDataSaved() {
                self.alertWithMessageAboutSuccessSaving()
            } else {
                self.alertWithMessageAboutFailureSaving {
                    self.saveProfileWithGrandCentralDispatch(nil)
                }
            }
        }
    }
    
    @IBAction func saveProfileWithOperations(_ sender: Any?) {
        activityIndicator.startAnimating()
        
        let operationDataManager = OperationDataManager()
        
        self.saveWithGrandCentralDispatchButton.isEnabled = false
        self.saveWithOperationsButton.isEnabled = false
        
        if self.profileNameTextField.text != operationDataManager.profileName {
            //Update name
            print("Update name")
            if let name = self.profileNameTextField.text {
                operationDataManager.updateProfileName(with: name)
            }
        }
        
        if self.profileDescriptionTextView.text != operationDataManager.profileDescription?.description {
            //Update description
            print("Update description")
            if let description = self.profileDescriptionTextView.text {
                operationDataManager.updateProfileDescription(with: description)
            }
        }
        
        if self.profileImageView.image?.pngData() != operationDataManager.profileImage?.pngData() {
            
            //Update image
            print("Update image")
            if let image = self.profileImageView.image {
                operationDataManager.updateProfileImage(with: image)
            }
        }
        
        operationDataManager.returnToMainQueue {
            self.activityIndicator.stopAnimating()
            
            //Out of editing mode if we saving data (case when we change image)
            if self.editButton.title != "Edit" {
                
                //func of our EditButton
                self.editProfile(nil)
                
            }
            
            if self.isAllDataSaved() {
                self.alertWithMessageAboutSuccessSaving()
            } else {
                self.alertWithMessageAboutFailureSaving {
                    self.saveProfileWithOperations(nil)
                }
            }
        }
    }
    
    //Use it after saving Data
    func alertWithMessageAboutSuccessSaving() {
        let alert = UIAlertController(title: "Canges saved", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (_) in
        }))
        self.present(alert, animated: true)
    }
    
    //Use it after saving Data
    func alertWithMessageAboutFailureSaving( _ repeatSaving: @escaping () -> Void ) {
        let alert = UIAlertController(title: "Not all data saved", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
        }))
        alert.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { (_) in
            repeatSaving()
        }))
        self.present(alert, animated: true)
    }
    
    //Use it if user change something and doesn't save, but press Done Button on NavigationBar
    func alertWithMessageAboutSaving() {
        
        let alert = UIAlertController(title: "Save changes", message: "After making edits", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "GCD", style: .default, handler: { (_) in
            
            //func of our SaveButton
            self.saveProfileWithGrandCentralDispatch(nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Operations", style: .default, handler: { (_) in
            
            //func of our SaveButton
            self.saveProfileWithOperations(nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Don't save", style: .default, handler: { (_) in
            
            self.initProfileInformation()
            
            self.saveWithGrandCentralDispatchButton.isEnabled = false
            self.saveWithOperationsButton.isEnabled = false
            
            self.editProfile(nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func editProfileImage(_ sender: Any) {
        selectingImage()
    }
    
    //Use it when typing something in TextField, TextView or when tap on Done button in NavigationBar.
    //Check only TextField and TextView.
    func isNothingInTextsChanged() -> Bool {
        if self.profileNameTextField.text == self.profileDataManager.profileName && self.profileDescriptionTextView.text == self.profileDataManager.profileDescription {
            return true
        } else {
            return false
        }
    }
    
    //Use it when save data.
    func isAllDataSaved() -> Bool {
        
        if self.profileNameTextField.text == self.profileDataManager.profileName {
            if self.profileDescriptionTextView.text == self.profileDataManager.profileDescription {
                if self.profileImageView.image?.pngData() == self.profileDataManager.profileImage?.pngData() {
                    return true
                }
            }
        }
            
        return false
        
    }
    
    //Use it in ViewDidLoad()
    func initProfileInformation() {
        
        //TextField and TextView
        self.profileNameTextField.text = self.profileDataManager.profileName
        self.profileDescriptionTextView.text = self.profileDataManager.profileDescription?.description
        
        //Initials
        if let initials = self.profileNameTextField.text?.first {
            self.profileInitialsLabel.text = String(describing: initials)
        } else {
            self.profileInitialsLabel.text = ""
        }
        
        //Label's
        self.profileNameLabel.text = self.profileDataManager.profileName
        self.profileDescriptionTextView.text = self.profileDataManager.profileDescription?.description
        
        //Image
        self.profileImageView.image = self.profileDataManager.profileImage
    }
    
    //NavigationBar Setup.
    func setupNavigationBar() {
        self.navigationItem.title = "My profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - UITextFieldDelegate, UITextViewDelegate

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    
    //Typing something in TextField (after every character)
    @IBAction func inputName(_ sender: UITextField) {
        if isNothingInTextsChanged() {
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
        if isNothingInTextsChanged() {
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
        } else {
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
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                picker.sourceType = .camera
                self.present(picker, animated: true)
            } else {
                self.present(alertWithNotAvailableMessage, animated: true)
            }
        }))
        
        //Selecting from Photo Album.
        actionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: { (_) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true)
            } else {
                self.present(alertWithNotAvailableMessage, animated: true)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
        }))
        
        actionSheet.ignoreNegativeWidthConstraints()
        self.present(actionSheet, animated: true)
    }
    
    //Picking image from Photo Album or Camera.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        //Picking...
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        //Sending image to our UIImageView.
        self.profileImageView.image = image
        picker.dismiss(animated: true)
        
        self.saveWithGrandCentralDispatchButton.isEnabled = true
        self.saveWithOperationsButton.isEnabled = true
        
    }
}
