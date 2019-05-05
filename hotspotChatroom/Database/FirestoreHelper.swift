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
    
    static func getUser(userId: String, completion: @escaping FIRDocumentSnapshotBlock){
        let docRef = db.collection("users").document(userId)
        docRef.getDocument(completion: completion)
    }
    
    static func updateUsername(userId: String, userName: String, completion: ((Error?) -> Void)?){
        db.collection("users").document(userId).updateData(["username":userName], completion: completion)
    }
    
    static func addChatroom(chatroom:Chatroom , completion: ((Error?) -> Void)?) {
        let newDocumentID = UUID().uuidString
        let chatroomWithId = Chatroom(name: chatroom.name, creatorUsername: chatroom.creatorUsername, chatroomId: newDocumentID, location: chatroom.location)
        db.collection("chatrooms").document(newDocumentID).setData(chatroomWithId.toDictionary(), completion: completion)
    }
    
    static func addMessage(message:Message, chatroomId:String, completion: ((Error?) -> Void)?) {
        let newDocumentID = UUID().uuidString
        let messageWithId = Message(username: message.username, userId: message.userId, message: message.message, messageId: newDocumentID, timestamp: message.timestamp)
        db.collection("chatrooms").document(chatroomId).collection("messages").document(newDocumentID).setData(messageWithId.toDictionary(), completion: completion)
    }
    
    static func chatSnapshotListener(chatroomId: String, completion: @escaping FIRQuerySnapshotBlock) -> ListenerRegistration {
        let listener = db.collection("chatrooms").document(chatroomId).collection("messages").order(by: "timestamp").addSnapshotListener(completion)
        return listener
    }
    
    // NEARBY DOCUMENT SEARCH BY Ryan Heitner copied from https://stackoverflow.com/a/51439726
    static func getChatroomsNearBy(latitude: Double, longitude: Double, meters: Double, completion: @escaping FIRQuerySnapshotBlock) {
        
        let r_earth : Double = 6378137  // Radius of earth in Meters
        
        // 1 degree lat in m
        let kLat = (2 * Double.pi / 360) * r_earth
        let kLon = (2 * Double.pi / 360) * r_earth * __cospi(latitude/180.0)
        
        let deltaLat = meters / kLat
        let deltaLon = meters / kLon
        
        let swGeopoint = GeoPoint(latitude: latitude - deltaLat, longitude: longitude - deltaLon)
        let neGeopoint = GeoPoint(latitude: latitude + deltaLat, longitude: longitude + deltaLon)
        
        let docRef : CollectionReference = db.collection("chatrooms")
        
        let query = docRef.whereField("location", isGreaterThan: swGeopoint).whereField("location", isLessThan: neGeopoint)
        query.getDocuments(completion: completion)
    }
    
}
