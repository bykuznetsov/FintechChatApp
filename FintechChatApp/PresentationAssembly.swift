//
//  PresentationAssembly.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 09.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

protocol IPresentationAssembly {
    
    //Создание экрана с каналами
    func conversationListViewController() -> ConversationsListViewController
    
    //Создание экрана с беседой
    func conversationViewController() -> ConversationViewController
    
    //Создание экрана профиля
    func profileViewController() -> ProfileViewController
    
    //Создание экрана со сменой темы в приложении
    func themesViewController() -> ThemesViewController
    
}

class PresentationAssembly: IPresentationAssembly {
    
    private let serviceAssembly: ServiceAssemblyProtocol
    
    init(serviceAssembly: ServiceAssemblyProtocol) {
        self.serviceAssembly = serviceAssembly
    }
    
    // MARK: - ConversationListViewController
    func conversationListViewController() -> ConversationsListViewController {
        
        guard let conversationListVC = ConversationsListViewController.storyboardInstanceFromId(
            storyboardName: "ConversationsListViewController",
            vcIdentifier: "ConversationsListViewController") as? ConversationsListViewController else {
            fatalError("Can't load ConversationsListViewController")
        }
        
        let model = conversationListModel()
        conversationListVC.applyDependencies(model: model, presentationAssembly: self)
        model.delegate = conversationListVC

        return conversationListVC
    }
    
    private func conversationListModel() -> IConversationListModel {
        return ConversationListModel(channelService: self.serviceAssembly.channelService,
                                     channelFRC: self.serviceAssembly.channelFRC)
    }
    
    // MARK: - ConversationViewController
    func conversationViewController() -> ConversationViewController {
        
        guard let conversationVC = ConversationViewController.storyboardInstance() as? ConversationViewController else { fatalError("Can't load ConversationVC")
        }
        
        let model = conversationModel()
        conversationVC.applyDependencies(model: model, presentationAssembly: self)
        model.delegate = conversationVC
        
        return conversationVC
    }
    
    private func conversationModel() -> IConversationModel {
        return ConversationModel(messageService: self.serviceAssembly.messageService,
                                     messageFRC: self.serviceAssembly.messageFRC)
    }
        
    // MARK: - ProfileViewController
    func profileViewController() -> ProfileViewController {
        
        guard let profileVC = ProfileViewController.storyboardInstanceFromId(
        storyboardName: "ProfileViewController",
        vcIdentifier: "ProfileViewController") as? ProfileViewController else {
            fatalError("Can't load ProfileViewController") }
        
        let model = profileModel()
        profileVC.applyDependencies(model: model, presentationAssembly: self)
        model.delegate = profileVC
        
        return profileVC
    }
    
    private func profileModel() -> IProfileModel {
        return ProfileModel(gcdProfileService: self.serviceAssembly.gcdProfileService,
                            operationProfileService: self.serviceAssembly.operationProfileService)
    }
    
    // MARK: - ThemesViewController
    func themesViewController() -> ThemesViewController {
        
        guard let themesVC = ThemesViewController.storyboardInstance() as? ThemesViewController else {
            fatalError("Can't load ThemesVC")
        }
        
        let model = themesModel()
        themesVC.applyDependencies(model: model, presentationAssembly: self)
        model.delegate = themesVC
        
        return themesVC
    }
    
    private func themesModel() -> IThemesModel {
        return ThemesModel(themeService: self.serviceAssembly.themeService)
    }
}
