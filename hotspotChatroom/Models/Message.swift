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
    let timestamp: Date
    
    func toDictionary() -> [String:Any] {
        return ["username":username, "userId":userId, "message":message, "messageId":messageId, "timestamp": Timestamp(date: timestamp)]
    }
    
    init(username:String, userId:String, message:String, messageId:String, timestamp:Date) {
        self.username = username
        self.userId = userId
        self.message = message
        self.messageId = messageId
        self.timestamp = timestamp
    }
    
    init?(data:[String:Any]) {
        guard let saveUsername = data["username"] as? String,
            let saveUserId = data["userId"] as? String,
            let saveMessage = data["message"] as? String,
            let saveMessageId = data["messageId"] as? String,
            let saveTimestamp = data["timestamp"] as? Timestamp
            else { return nil }
        self.username = saveUsername
        self.userId = saveUserId
        self.message = saveMessage
        self.messageId = saveMessageId
        self.timestamp = saveTimestamp.dateValue()
    }
}
