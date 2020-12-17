//
//  FintechChatAppTests.swift
//  FintechChatAppTests
//
//  Created by Никита Кузнецов on 01.12.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

@testable import FintechChatApp
import XCTest

class FintechChatAppTests: XCTestCase {
    
    // MARK: - ThemeService
    
    func testThemeService() throws {
        //Arrange
        let userDefaultsEntityMock = UserDefaultsEntityMock()
        let themeService: IThemeService = ThemeService(userDefaultsEntity: userDefaultsEntityMock)
        
        //Act
        themeService.setTheme(new: .classic)
        
        //Assert
        //First time - when init, second time - when set theme
        XCTAssertEqual(userDefaultsEntityMock.gettingDefaultsCount, 2)
    }
    
    // MARK: - ChannelService
    
    func testFetchingAndCachingChannelsInChannelService() throws {
        //Arrange
        let saveRequestMock = SaveRequestMock()
        let channelRequestMock = ChannelRequestMock()
        let channelPathMock = ChannelPathMock()
        let fsChannelRequestMock = FSChannelRequestMock()
        
        let channelService: IChannelService = ChannelService(saveRequest: saveRequestMock,
                                                             channelRequest: channelRequestMock,
                                                             channelPath: channelPathMock,
                                                             fsChannelRequest: fsChannelRequestMock)
        
        //Act
        channelService.fetchAndCacheChannels()

        //Assert
        XCTAssertEqual(channelPathMock.gettingReferenceCount, 1)
    }
    
    func testAddingNewChannelInChannelService() throws {
        //Arrange
        let saveRequestMock = SaveRequestMock()
        let channelRequestMock = ChannelRequestMock()
        let channelPathMock = ChannelPathMock()
        let fsChannelRequestMock = FSChannelRequestMock()
        
        let channelService: IChannelService = ChannelService(saveRequest: saveRequestMock,
                                                             channelRequest: channelRequestMock,
                                                             channelPath: channelPathMock,
                                                             fsChannelRequest: fsChannelRequestMock)
        
        let channel = Channel(identifier: "123", name: "Channel123", lastMessage: "Hello123", lastActivity: Date())
        
        //Act
        channelService.addNewChannel(channel: channel)

        //Assert
        XCTAssertEqual(fsChannelRequestMock.addingNewChannelCount, 1)
        XCTAssertEqual(fsChannelRequestMock.addedChannel, channel)
    }
    
    func testDeletingChannelInChannelService() throws {
        //Arrange
        let saveRequestMock = SaveRequestMock()
        let channelRequestMock = ChannelRequestMock()
        let channelPathMock = ChannelPathMock()
        let fsChannelRequestMock = FSChannelRequestMock()
        
        let channelService: IChannelService = ChannelService(saveRequest: saveRequestMock,
                                                             channelRequest: channelRequestMock,
                                                             channelPath: channelPathMock,
                                                             fsChannelRequest: fsChannelRequestMock)
        
        let documentPath = "12345"
        
        //Act
        channelService.deleteChannel(at: documentPath)

        //Assert
        XCTAssertEqual(fsChannelRequestMock.deletingChannelCount, 1)
        XCTAssertEqual(fsChannelRequestMock.deletedChannelDocumentPath, documentPath)
    }
    
    // MARK: - MessageService
    
    func testFetchingAndCachingMessagesInMessageService() throws {
        //Arrange
        let saveRequestMock = SaveRequestMock()
        let messageRequestMock = MessageRequestMock()
        let messagePathMock = MessagePathMock()
        let channelRequestMock = ChannelRequestMock()
        let fsMessageRequest = FSMessageRequestMock()
        
        let messageService: IMessageService = MessageService(saveRequest: saveRequestMock,
                                                             messageRequest: messageRequestMock,
                                                             messagePath: messagePathMock,
                                                             channelRequest: channelRequestMock,
                                                             fsMessageRequest: fsMessageRequest,
                                                             documentId: "")
        
        //Act
        messageService.fetchAndCacheMessages(documentId: "")
        
        //Assert
        XCTAssertEqual(messagePathMock.gettingReferenceCount, 1)
    }
    
    func testAddingNewMessageInMessageService() throws {
        //Arrange
        let saveRequestMock = SaveRequestMock()
        let messageRequestMock = MessageRequestMock()
        let messagePathMock = MessagePathMock()
        let channelRequestMock = ChannelRequestMock()
        let fsMessageRequestMock = FSMessageRequestMock()
        
        let messageService: IMessageService = MessageService(saveRequest: saveRequestMock,
                                                             messageRequest: messageRequestMock,
                                                             messagePath: messagePathMock,
                                                             channelRequest: channelRequestMock,
                                                             fsMessageRequest: fsMessageRequestMock,
                                                             documentId: "")
        
        let message = Message(identifier: "123", content: "Hello123", created: Date(), senderId: "123", senderName: "Nikita")
        
        //Act
        messageService.addNewMessage(message: message)
        
        //Assert
        XCTAssertEqual(fsMessageRequestMock.addingNewMessageCount, 1)
        XCTAssertEqual(fsMessageRequestMock.addedMessage, message)
    }
    
    func testDeletingMessageInMessageService() throws {
        //Arrange
        let saveRequestMock = SaveRequestMock()
        let messageRequestMock = MessageRequestMock()
        let messagePathMock = MessagePathMock()
        let channelRequestMock = ChannelRequestMock()
        let fsMessageRequestMock = FSMessageRequestMock()
        
        let messageService: IMessageService = MessageService(saveRequest: saveRequestMock,
                                                             messageRequest: messageRequestMock,
                                                             messagePath: messagePathMock,
                                                             channelRequest: channelRequestMock,
                                                             fsMessageRequest: fsMessageRequestMock,
                                                             documentId: "")
        
        let documentPath = "12345"
        
        //Act
        messageService.deleteMessage(at: documentPath)
        
        //Assert
        XCTAssertEqual(fsMessageRequestMock.deletingMessageCount, 1)
        XCTAssertEqual(fsMessageRequestMock.deletedMessageDocumentPath, documentPath)
    }
    
    // MARK: - ImagesService
    
    func testLoadingImageInImagesService() throws {
        //Arrange
        let requestSenderMock = RequestSenderMock()
        let imagesService: IImagesService = ImagesService(networkRequestSender: requestSenderMock)
        
        //Act
        imagesService.loadImage(urlImage: "") { (_) in
            
        }
        
        //Assert
        XCTAssertEqual(requestSenderMock.sendingRequestCount, 1)
    }
    
    func testLoadingImagesInImagesService() throws {
        //Arrange
        let requestSenderMock = RequestSenderMock()
        let imagesService: IImagesService = ImagesService(networkRequestSender: requestSenderMock)
        
        //Act
        imagesService.loadImages { (_) in
            
        }
        
        //Assert
        XCTAssertEqual(requestSenderMock.sendingRequestCount, 1)
    }
    
}
