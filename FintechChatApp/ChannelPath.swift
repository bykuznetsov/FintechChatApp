//
//  ChannelPath.swift
//  FintechChatApp
//
//  Created by Никита Кузнецов on 11.11.2020.
//  Copyright © 2020 dreamTeam. All rights reserved.
//

import Foundation
import Firebase

protocol IChannelPath {
    var db: Firestore { get }
    var reference: CollectionReference { get }
}

///Make something with collection of channels in Firestore server (for example: fetching channels from server)
class ChannelPath: IChannelPath {
    internal lazy var db: Firestore = Firestore.firestore()
    lazy var reference: CollectionReference = db.collection("channels")
}
