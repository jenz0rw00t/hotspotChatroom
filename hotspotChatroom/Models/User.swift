//
//  User.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-10.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation

struct User {
    let userId:String
    let email:String
    var username:String
    
    func toDictionary() -> [String:Any] {
        return ["userId":userId, "email":email, "username":username]
    }
    
    init(userId:String, email:String, username:String) {
        self.userId = userId
        self.email = email
        self.username = username
    }
    
    init?(data:[String:Any]) {
        guard let userId = data["userId"] as? String,
        let email = data["email"] as? String,
        let userName = data["username"] as? String
            else { return nil }
        self.userId = userId
        self.email = email
        self.username = userName
    }
}
