//
//  Message.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-23.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation
import Firebase

struct Message {
    let username: String
    let userId: String
    let message: String
    let messageId: String
    //  TODO:  let userRef: DocumentReference
    
    func toDictionary() -> [String:Any] {
        return ["username":username, "userId":userId, "message":message, "messageId":messageId]
    }
    
    init(username:String, userId:String, message:String, messageId:String) {
        self.username = username
        self.userId = userId
        self.message = message
        self.messageId = messageId
    }
    
    init?(data:[String:Any]) {
        guard let saveUsername = data["name"] as? String,
            let saveUserId = data["userId"] as? String,
            let saveMessage = data["message"] as? String,
            let saveMessageId = data["messageId"] as? String
            else { return nil }
        self.username = saveUsername
        self.userId = saveUserId
        self.message = saveMessage
        self.messageId = saveMessageId
    }
}
