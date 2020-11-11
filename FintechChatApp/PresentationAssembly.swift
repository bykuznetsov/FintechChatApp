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
        let conversationListVC = conversationListViewController()
        model.delegate = conversationListVC
        
        return conversationListVC
    }
    
    private func conversationListModel() -> IConversationListModel {
        return ConversationListModel(channelService: self.serviceAssembly.channelService,
                                     channelFRC: self.serviceAssembly.channelFRC)
    }
    
    // MARK: - ConversationViewController
    func conversationViewController() -> ConversationViewController {
         return ConversationViewController()
     }
        
    // MARK: - ProfileViewController
    func profileViewController() -> ProfileViewController {
        return ProfileViewController()
    }
    
    // MARK: - ThemesViewController
    func themesViewController() -> ThemesViewController {
        return ThemesViewController()
    }
    
}
