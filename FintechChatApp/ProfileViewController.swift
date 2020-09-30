//
//  ProfileViewController.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 17.09.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController{
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileFieldForImage: UIView!
    
    convenience init() {
        self.init()
        print(saveButton.frame) //Не печатается
//        //Из документации Apple: "When using a storyboard to define
//        //your view controller and its associated views, you
//        //never initialize your view controller class directly."
//        //Значит, что используя .storyboard, мы не сможем пользоваться методом init()
//        //напрямую и инициализация происходит средствами .storyboard
//        //Но и в принципе на этом моменте мы не смогли бы получить значение .frame
//        //т.к. эти значения будут известны после инициализации самой кнопки,
//        //которая произойдет во время вызова метода awakeFromNib() у ViewController,
//        //который возовется позже, чем init() (Рассматриваем случай с использованием
//        //.storyboard).
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(saveButton.frame)
        
        setupProfileFieldForImage()
        setupSaveButton()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(saveButton.frame) //Размеры .frame изменились, т.к. до этого выполнились методы
        //viewWillLayoutSubviews() и viewDidLayoutSubviews(), в которых выполняется Autolayout
        //(вычисления значений .frame в соответсвии с Constraints, которые мы установили
        //на наши View's, в том числе и на кнопку Edit).
        //Ведь мы используем .storyboard, в котором используем Constraints.
        //Изначально в методе viewDidLoad() распечатались значения, которые мы указали "как бы"
        //по стандарту в файле .storyboard, а Autolayout происходит позже, поэтому значения отличны.
        //Те же самые значения будут выведены в консоль при вызове метода viewDidLayoutSubviews(),
        //в котором как раз (Did) будут завершены все расчеты .frame'ов у различных View's.
    }
    
    @IBAction func savingProfile(_ sender: Any) {}
    
    @IBAction func editingProfile(_ sender: Any) {
        selectingImage()
    }
    
    //Right navigationBarItem.
    @IBAction func closeProfile(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //NavigationBar Setup.
    func setupNavigationBar() {
        self.navigationController?.title = "My profile"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    }
    
    //UI Setups.
    func setupProfileFieldForImage() {
        profileFieldForImage.layer.cornerRadius = profileFieldForImage.bounds.height/2
        profileFieldForImage.layer.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9137254902, blue: 0.1764705882, alpha: 1)
        profileFieldForImage.layer.borderWidth = 7
        profileFieldForImage.layer.borderColor = #colorLiteral(red: 0.9419991374, green: 0.9363991618, blue: 0.9463036656, alpha: 1)
    }
    
    func setupSaveButton() {
        saveButton.layer.cornerRadius = 14
        saveButton.layer.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
    }
    
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //Function which present to us ActionSheet (Alert) with a choice of getting image (From Camera or Photo Album).
    func selectingImage(){
        
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
        if profileImage.image != nil {
            actionSheet.addAction(UIAlertAction(title: "Delete Photo", style: .destructive , handler:{ (UIAlertAction) in
                self.profileImage.image = nil
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
        self.profileImage.image = image
        picker.dismiss(animated: true)
    }
    
}
