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
        
        let model = conversationListModel()
        let conversationListVC = ConversationsListViewController(presentationAssembly: self, model: model)
        model.delegate = conversationListVC
        
        return conversationListVC
    }
    
    private func conversationListModel() -> IConversationListModel {
        return ConversationListModel(channelService: self.serviceAssembly.channelService,
                                     channelFRC: self.serviceAssembly.channelFRC)
    }
    
    // MARK: - ConversationViewController
    func conversationViewController() -> ConversationViewController {
        
        let model = conversationModel()
        let conversationVC = ConversationViewController(presentationAssembly: self, model: model)
        model.delegate = conversationVC
        
        return conversationVC
    }
    
    private func conversationModel() -> IConversationModel {
        return ConversationModel(messageService: self.serviceAssembly.messageService,
                                     messageFRC: self.serviceAssembly.messageFRC)
    }
        
    // MARK: - ProfileViewController
    func profileViewController() -> ProfileViewController {
        
        let model = profileModel()
        let profileVC = ProfileViewController(presentationAssembly: self, model: model)
        model.delegate = profileVC
        
        return profileVC
    }
    
    private func profileModel() -> IProfileModel {
        return ProfileModel(gcdProfileService: self.serviceAssembly.gcdProfileService,
                            operationProfileService: self.serviceAssembly.operationProfileService)
    }
    
    // MARK: - ThemesViewController
    func themesViewController() -> ThemesViewController {
        
        let model = themesModel()
        let themesVC = ThemesViewController(presentationAssembly: self, model: model)
        model.delegate = themesVC
        
        return themesVC
    }
    
    private func themesModel() -> IThemesModel {
        return ThemesModel(themeService: self.serviceAssembly.themeService)
    }
}
