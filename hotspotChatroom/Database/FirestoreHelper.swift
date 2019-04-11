//
//  FirestoreHelper.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-11.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation
import Firebase

let db = Firestore.firestore()

struct FirestoreHelper {
    
    static func addUser(user: User, completion: ((Error?) -> Void)?) {
        db.collection("users").document("\(user.userId)").setData(user.toDictionary(), completion: completion)
    }
    
    
    
}
