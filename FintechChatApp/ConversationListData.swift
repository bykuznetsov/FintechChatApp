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
        Dialog(name: "Kirill Kurochckin", date: Date(timeIntervalSince1970: 1601492103), message: ""),
        Dialog(name: "Dmitry Voronin", date: Date(timeIntervalSince1970: 1601396841), message: "Tommorow we will go to cinema"),
        Dialog(name: "Garick Markov", date: Date(timeIntervalSince1970: 1600096841), message: "Nice to see you on this platform"),
        Dialog(name: "McDonalds", date: Date(timeIntervalSince1970: 1601492103), message: ""),
        Dialog(name: "Anton Mosienko", date: Date(timeIntervalSince1970: 1601492103), message: "Do you want to join at our party this weekend?"),
        Dialog(name: "Pomella Anderson", date: Date(timeIntervalSince1970: 16016841), message: nil),
        Dialog(name: "Max Afanas'ev", date: Date(timeIntervalSince1970: 1301296841), message: "How are you?"),
        Dialog(name: "Mrs Smith", date: Date(timeIntervalSince1970: 1600992103), message: nil),
        Dialog(name: "Denis Harlamov", date: Date(timeIntervalSince1970: 42323940), message: nil),
        Dialog(name: "Artem Voloshin", date: Date(timeIntervalSince1970: 1600892103), message: "I need your help! Our grandfather bought a new car without wheels, can you borrow to me your wheels?"),
        Dialog(name: "Project Alice", date: Date(timeIntervalSince1970: 1600792103), message: "Corporation Umbrella again doing evil"),
        Dialog(name: "Yuri Dud'", date: Date(timeIntervalSince1970: 1600692103), message: "I want to take interview with you. Will you be free at next Friday?"),
        Dialog(name: "Leonid Gellert", date: Date(timeIntervalSince1970: 1600092103), message: ""),
        Dialog(name: "Lays", date: Date(timeIntervalSince1970: 1600592103), message: "Find promocodes in our products and win prizes!"),
        Dialog(name: "Grandfather", date: Date(timeIntervalSince1970: 1600492103), message: "I found 1 wheel in neighbour house, we need 3 more :)"),
        Dialog(name: "Sarah Conor", date: Date(timeIntervalSince1970: 1500092103), message: ""),
        Dialog(name: "Neighbour", date: Date(timeIntervalSince1970: 1600392103), message: "Give me back my wheel"),
        Dialog(name: "Avatar", date: Date(timeIntervalSince1970: 1600292103), message: nil),
        Dialog(name: "Alexandr Markov", date: Date(timeIntervalSince1970: 1600392103), message: "Hola amigo, ¿cómo estás? Me gustaría vernos el próximo fin de semana si no te importa. ¿Cómo estás?")
    ]
    
    //Model of test data.
    struct Dialog {
        let name: String
        let date: Date
        let message: String?
    }
    
    //New Model
    struct Channel {
        let identifier: String
        let name: String
        let lastMessage: String?
        let lastActivity: Date?
    }
    
}
