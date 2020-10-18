//
//  ConversationData.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 08.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

class ConversationData {
    
    //Test data.
    static var messages: [MessageModel] = [
        MessageModel(text: "Hello. How are you, my friend?", isOutgoingMessage: true),
        MessageModel(text: "Hello! I'm fine, what about you?", isOutgoingMessage: false),
        MessageModel(text: "I got sick :(", isOutgoingMessage: true),
        MessageModel(text: "Wow, what's happen?", isOutgoingMessage: false),
        MessageModel(text: "I have headache and stomachache. Tommorow I will need get a package from post office, but I couldn't make it. Can you help me, please?", isOutgoingMessage: true),
        MessageModel(text: "Ofcourse I will help you. When and where it will be?", isOutgoingMessage: false),
        MessageModel(text: "2:00 PM on the Red street", isOutgoingMessage: true),
        MessageModel(text: "Thank you very much", isOutgoingMessage: true),
        MessageModel(text: "No problem! I hope we will meet in the end of this moth, because 28 of September is the date of my birthday. I want to invite you and your parents!", isOutgoingMessage: false),
        MessageModel(text: "Oh, ofcourse I accept your invitation. See you soon!", isOutgoingMessage: true),
    ]
    
    //Model of test data.
    struct MessageModel {
        let text: String
        let isOutgoingMessage: Bool
    }
    
    //New Model
    struct Message {
        let content: String
        let created: Date
        let senderId: String
        let senderName: String
    }
    
}
