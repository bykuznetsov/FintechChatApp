//
//  ProfileViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 17.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, IProfileModelDelegate {
    
    var presentationAssembly: IPresentationAssembly?
    var model: IProfileModel?
    
    private var tinkoffParticleGesture: TinkoffParticleGesture = TinkoffParticleGesture()
    private var shakeAnimation: ShakeAnimation = ShakeAnimation()
    
    @IBOutlet weak var saveWithGrandCentralDispatchButton: UIButton!
    @IBOutlet weak var saveWithOperationsButton: UIButton!
    
    @IBOutlet weak var editButton: UIButton!
    private var editMode: Bool = false
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileFieldForImage: UIView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profileInitialsLabel: UILabel!
    
    @IBOutlet weak var profileDescriptionTextView: UITextView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureActivityIndicator()
        configureTextFields()
        configureParticleEffect()
        initProfileInformation()
        addKeyboardNotifications()
    }
    
    func applyDependencies(model: IProfileModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.presentationAssembly = presentationAssembly
    }
    
    private func configureTextFields() {
        self.profileNameTextField.delegate = self
        self.profileDescriptionTextView.delegate = self
    }
    
    private func configureParticleEffect() {
        let longTapGestureRecognizer = self.tinkoffParticleGesture.longTapGestureRecognizer
        let panGestureRecognizer = self.tinkoffParticleGesture.panGestureRecognizer
        
        longTapGestureRecognizer.delegate = self
        panGestureRecognizer.delegate = self
        
        self.navigationController?.view.addGestureRecognizer(longTapGestureRecognizer)
        self.navigationController?.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    //Left navigationBarItem.
    @IBAction func editProfile(_ sender: Any?) {
        
        if editMode == false { //Switch to Edit mode.
            
            editMode = true
            
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
            self.shakeAnimation.startShaking(view: self.editButton)
            
        } else if editMode { //Return from Edit mode
            
            editMode = false
            
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
            self.editButton.isEnabled = false
            self.shakeAnimation.stopShaking(view: self.editButton, completionHandler: { [weak self] in
                self?.editButton.isEnabled = true
            })
            
        }
        
    }
    
    //Right navigationBarItem.
    @IBAction func closeProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveProfileWithGrandCentralDispatch(_ sender: Any?) {
        
        guard let model = self.model else { return }
        
        self.activityIndicator.startAnimating()
    
        self.saveWithGrandCentralDispatchButton.isEnabled = false
        self.saveWithOperationsButton.isEnabled = false
        
        if self.profileNameTextField.text != model.gcdGetProfileName() {
            //Update name
            print("Update name")
            if let name = self.profileNameTextField.text {
                model.gcdUpdateProfileName(with: name)
            }
        }
        
        if self.profileDescriptionTextView.text != model.gcdGetProfileDescription() {
            //Update description
            print("Update description")
            if let description = self.profileDescriptionTextView.text {
                model.gcdUpdateProfileDescription(with: description)
            }
        }
        
        if self.profileImageView.image?.pngData() != model.gcdGetProfileImage()?.pngData() {
            //Update image
            print("Update image")
            if let image = self.profileImageView.image {
                model.gcdUpdateProfileImage(with: image)
            }
        }
        
        self.activityIndicator.stopAnimating()
        
        //Out of editing mode if we saving data (case when we change image)
        if editMode {
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
    
    @IBAction func saveProfileWithOperations(_ sender: Any?) {
        
        guard let model = self.model else { return }
        
        activityIndicator.startAnimating()
        
        self.saveWithGrandCentralDispatchButton.isEnabled = false
        self.saveWithOperationsButton.isEnabled = false
        
        if self.profileNameTextField.text != model.operationGetProfileName() {
            //Update name
            print("Update name")
            if let name = self.profileNameTextField.text {
                model.operationUpdateProfileName(with: name)
            }
        }
        
        if self.profileDescriptionTextView.text != model.operationGetProfileDescription() {
            //Update description
            print("Update description")
            if let description = self.profileDescriptionTextView.text {
                model.operationUpdateProfileDescription(with: description)
            }
        }
        
        if self.profileImageView.image?.pngData() != model.operationGetProfileImage()?.pngData() {
            
            //Update image
            print("Update image")
            if let image = self.profileImageView.image {
                model.operationUpdateProfileImage(with: image)
            }
        }
        
        //operationDataManager.returnToMainQueue {
            self.activityIndicator.stopAnimating()
            
            //Out of editing mode if we saving data (case when we change image)
            if editMode {
                
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
    
    //Use it after saving Data
    private func alertWithMessageAboutSuccessSaving() {
        let alert = UIAlertController(title: "Canges saved", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default, handler: { (_) in
        }))
        self.present(alert, animated: true)
    }
    
    //Use it after saving Data
    private func alertWithMessageAboutFailureSaving( _ repeatSaving: @escaping () -> Void ) {
        let alert = UIAlertController(title: "Not all data saved", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
        }))
        alert.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { (_) in
            repeatSaving()
        }))
        self.present(alert, animated: true)
    }
    
    //Use it if user change something and doesn't save, but press Done Button on NavigationBar
    private func alertWithMessageAboutSaving() {
        
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
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in }))
        
        self.present(alert, animated: true)
    }
    
    @IBAction func editProfileImage(_ sender: Any) {
        selectingImage()
    }
    
    //Use it when typing something in TextField, TextView or when tap on Done button in NavigationBar.
    //Check only TextField and TextView.
    private func isNothingInTextsChanged() -> Bool {
        
        guard let model = self.model else { return false }
        
        if self.profileNameTextField.text == model.gcdGetProfileName() && self.profileDescriptionTextView.text == model.gcdGetProfileDescription() {
            return true
        } else {
            return false
        }
    }
    
    //Use it when save data.
    private func isAllDataSaved() -> Bool {
        
        guard let model = self.model else { return false }
        
        if self.profileNameTextField.text == model.gcdGetProfileName() {
            if self.profileDescriptionTextView.text == model.gcdGetProfileDescription() {
                if self.profileImageView.image?.pngData() == model.gcdGetProfileImage()?.pngData() {
                    return true
                }
            }
        }
            
        return false
        
    }
    
    //Use it in ViewDidLoad()
    private func initProfileInformation() {
        
        guard let model = self.model else { return }
        
        //TextField and TextView
        self.profileNameTextField.text = model.gcdGetProfileName()
        self.profileDescriptionTextView.text = model.gcdGetProfileDescription()
        
        //Initials
        if let initials = self.profileNameTextField.text?.first {
            self.profileInitialsLabel.text = String(describing: initials)
        } else {
            self.profileInitialsLabel.text = ""
        }
        
        //Label's
        self.profileNameLabel.text = model.gcdGetProfileName()
        self.profileDescriptionTextView.text = model.gcdGetProfileDescription()
        
        //Image
        self.profileImageView.image = model.gcdGetProfileImage()
    }
    
    //NavigationBar Setup.
    private func configureNavigationBar() {
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
        
        //Selecting from Server.
        actionSheet.addAction(UIAlertAction(title: "Load", style: .default, handler: { (_) in
            guard let imagesVC = self.presentationAssembly?.imagesViewController() else { return }
            let imagesVCWithNavigation = UINavigationController(rootViewController: imagesVC)
            imagesVC.delegate = self
            self.present(imagesVCWithNavigation, animated: true)
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

extension ProfileViewController: ImageDelegate {
    func imageTransfer(image: UIImage) {
        
        self.profileImageView.image = image
        
        self.saveWithGrandCentralDispatchButton.isEnabled = true
        self.saveWithOperationsButton.isEnabled = true
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ProfileViewController: UIGestureRecognizerDelegate {

    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
