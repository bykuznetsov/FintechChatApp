//
//  ConversationListData.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 08.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation

class ConversationListData {
    
    //You can get time if now in Unix here: https://www.unixtimestamp.com/index.php
    //Test data.
    static var dialogs: [Dialog] = [
        Dialog(isOnline: true,
               dialogInfo: [
                DialogInfo(name: "Kirill Kurochckin", date: Date(timeIntervalSince1970: 1601492103), message: "", hasUnreadMessages: true),
                DialogInfo(name: "Dmitry Voronin", date: Date(timeIntervalSince1970: 1601396841), message: "Tommorow we will go to cinema", hasUnreadMessages: false),
                DialogInfo(name: "Garick Markov", date: Date(timeIntervalSince1970: 1600096841), message: "Nice to see you on this platform", hasUnreadMessages: false),
                DialogInfo(name: "McDonalds", date: Date(timeIntervalSince1970: 1601492103), message: "", hasUnreadMessages: false),
                DialogInfo(name: "Anton Mosienko", date: Date(timeIntervalSince1970: 1601492103), message: "Do you want to join at our party this weekend?", hasUnreadMessages: true),
                DialogInfo(name: "Pomella Anderson", date: Date(timeIntervalSince1970: 16016841), message: nil, hasUnreadMessages: false),
                DialogInfo(name: "Max Afanas'ev", date: Date(timeIntervalSince1970: 1301296841), message: "How are you?", hasUnreadMessages: true),
                DialogInfo(name: "Mrs Smith", date: Date(timeIntervalSince1970: 1600992103), message: nil, hasUnreadMessages: true)
        ]),
        
        Dialog(isOnline: false,
               dialogInfo: [
                DialogInfo(name: "Denis Harlamov", date: Date(timeIntervalSince1970: 42323940), message: nil, hasUnreadMessages: false),
                DialogInfo(name: "Artem Voloshin", date: Date(timeIntervalSince1970: 1600892103), message: "I need your help! Our grandfather bought a new car without wheels, can you borrow to me your wheels?", hasUnreadMessages: false),
                DialogInfo(name: "Project Alice", date: Date(timeIntervalSince1970: 1600792103), message: "Corporation Umbrella again doing evil", hasUnreadMessages: true),
                DialogInfo(name: "Yuri Dud'", date: Date(timeIntervalSince1970: 1600692103), message: "I want to take interview with you. Will you be free at next Friday?", hasUnreadMessages: false),
                DialogInfo(name: "Leonid Gellert", date: Date(timeIntervalSince1970: 1600092103), message: "", hasUnreadMessages: true),
                DialogInfo(name: "Lays", date: Date(timeIntervalSince1970: 1600592103), message: "Find promocodes in our products and win prizes!", hasUnreadMessages: false),
                DialogInfo(name: "Grandfather", date: Date(timeIntervalSince1970: 1600492103), message: "I found 1 wheel in neighbour house, we need 3 more :)", hasUnreadMessages: false),
                DialogInfo(name: "Sarah Conor", date: Date(timeIntervalSince1970: 1500092103), message: "", hasUnreadMessages: false),
                DialogInfo(name: "Neighbour", date: Date(timeIntervalSince1970: 1600392103), message: "Give me back my wheel", hasUnreadMessages: false),
                DialogInfo(name: "Avatar", date: Date(timeIntervalSince1970: 1600292103), message: nil, hasUnreadMessages: true),
                DialogInfo(name: "Alexandr Markov", date: Date(timeIntervalSince1970: 1600392103), message: "Hola amigo, ¿cómo estás? Me gustaría vernos el próximo fin de semana si no te importa. ¿Cómo estás?", hasUnreadMessages: true),
        ])
    ]
    
    //Model of test data.
    struct Dialog {
        let isOnline: Bool
        var dialogInfo: [DialogInfo]
    }
    
    struct DialogInfo {
        let name: String
        let date: Date
        let message: String?
        let hasUnreadMessages: Bool
    }
    
}
