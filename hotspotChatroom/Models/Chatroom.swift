//
//  Chatroom.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-20.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation
import Firebase

struct Chatroom {
    let name: String
    let creatorUsername: String
    let chatroomId: String
    let location: GeoPoint
    //   TODO: let creatorRef: DocumentReference
    
    func toDictionary() -> [String:Any] {
        return ["name":name, "creatorUsername":creatorUsername, "chatroomId":chatroomId, "location":location]
    }
    
    init(name:String, creatorUsername:String, chatroomId:String, location:GeoPoint) {
        self.name = name
        self.creatorUsername = creatorUsername
        self.chatroomId = chatroomId
        self.location = location
    }
    
    init?(data:[String:Any]) {
        guard let saveName = data["name"] as? String,
            let saveCreatorUsername = data["creatorUsername"] as? String,
            let saveChatroomId = data["chatroomId"] as? String,
            let saveLocation = data["location"] as? GeoPoint
            else { return nil }
        self.name = saveName
        self.creatorUsername = saveCreatorUsername
        self.chatroomId = saveChatroomId
        self.location = saveLocation
    }
}
