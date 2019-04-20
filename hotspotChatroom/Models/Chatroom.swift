//
//  Chatroom.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-20.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation

struct Chatroom {
    let name: String
    let creatorUsername: String
    let chatroomId: String
    
    // TODO: Save and hande location
    
    func toDictionary() -> [String:Any] {
        return ["name":name, "creatorUsername":creatorUsername, "chatroomId":chatroomId]
    }
    
    init(name:String, creatorUsername:String, chatroomId:String) {
        self.name = name
        self.creatorUsername = creatorUsername
        self.chatroomId = chatroomId
    }
    
    init?(data:[String:Any]) {
        guard let saveName = data["name"] as? String,
            let saveCreatorUsername = data["creatorUsername"] as? String,
            let saveChatroomId = data["chatroomId"] as? String
            else { return nil }
        self.name = saveName
        self.creatorUsername = saveCreatorUsername
        self.chatroomId = saveChatroomId
    }
}
