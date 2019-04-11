//
//  LogInHelper.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-11.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth

struct LogInHelper {
    
    static private let authRef = Auth.auth()
    
    static func signUpUser(email: String, password: String, completion:AuthDataResultCallback?) {
        authRef.createUser(withEmail: email, password: password, completion: completion)
    }
    
    static func signInUser(email: String, password: String, completion: AuthDataResultCallback?) {
        authRef.signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func signOutUser() {
        do {
            try authRef.signOut()
        } catch let error {
            print("SIGN OUT ERROR: \(error.localizedDescription)")
        }
    }
    
    static func getCurrentUserID() -> String? {
        return authRef.currentUser?.uid
    }
    
    static func signedInListener(listener: @escaping AuthStateDidChangeListenerBlock) -> AuthStateDidChangeListenerHandle {
        let handler = authRef.addStateDidChangeListener(listener)
        return handler
    }
    
    static func removeSignInListener(listener: AuthStateDidChangeListenerHandle) {
        authRef.removeStateDidChangeListener(listener)
    }
    
}
