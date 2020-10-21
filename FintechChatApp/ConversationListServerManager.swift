//
//  ConversationListData.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 08.10.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class ConversationListServerManager {
    
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    var channels: [Channel]  = []
    
    //Data Model
    struct Channel {
        let identifier: String
        let name: String
        let lastMessage: String?
        let lastActivity: Timestamp?
    }
    
    func fetchingChannels(for tableView: UITableView) {
        
        reference.addSnapshotListener { snapshot, error in
            
            guard let documents = snapshot?.documents else { return }
            
            self.channels = documents.compactMap { queryDocumentSnapshot -> Channel? in
                
                let identifier = queryDocumentSnapshot.documentID
                
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let lastMessage = data["lastMessage"] as? String ?? ""
                let lastActivity = data["lastActivity"] as? Timestamp
                
                //Remove invalid data
                if name.isEmpty {
                    return nil
                }
                
                return Channel(identifier: identifier, name: name, lastMessage: lastMessage, lastActivity: lastActivity)
            }
            
            //Sort data by date
            //self.channels = self.channels.filter( { ($0.lastActivity != nil) } ).sorted(by: { $0.lastActivity!.compare($1.lastActivity!) == .orderedDescending  })
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            
        }
    }
    
    func addNewChannel(channel: Channel) {
        reference.addDocument(data: [
            "name" : channel.name,
            "lastMessage" : channel.lastMessage as String? as Any,
            "lastActivity" : channel.lastActivity as Timestamp? as Any
            ])
    }
    
}
