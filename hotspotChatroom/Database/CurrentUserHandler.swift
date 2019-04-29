//
//  CurrentUserHandler.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-27.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol CurrentUserHandlerDelegate {
    func currentUserUpdated()
}

final class CurrentUserHandler: NSObject {
    
    var currentUser: User?
    
    var delegate: CurrentUserHandlerDelegate?
    
    // MARK: - Singleton constructor
    
    static let shared = CurrentUserHandler()
    
    private override init() {
        super .init()
        getCurrentUser()
        startAuthListener()
    }
    
    // MARK: - Functions for wide use
    
    func getUser() -> User? {
        return currentUser
    }
    
    func updateUser() {
        getCurrentUser()
    }
    
    func signOut() {
        LogInHelper.signOutUser()
        currentUser = nil
    }

    // MARK: - User and auth functions
    
    private var authListener: AuthStateDidChangeListenerHandle?
    
    private func startAuthListener() {
        authListener = LogInHelper.signedInListener { (auth, user) in
            if user == nil {
                print("---CURRENT USER HANDLER: USER IS NIL")
                self.currentUser = nil
            } else if user?.uid != self.currentUser?.userId {
                print("---CURRENT USER HANDLER: USER IS NOT THE SAME?")
                print("user?.uid = \(user?.uid ?? "nil") currentUser?.userId = \(self.currentUser?.userId ?? "nil")")
                self.setCorrectUser(userId: user!.uid)
            }
        }
    }
    
    private func setCorrectUser(userId:String){
        FirestoreHelper.getUser(userId: userId) { (snapshot, error) in
            if error != nil {
                print("GET USER ERROR: \(error!.localizedDescription)")
                return
            }
            guard let snap = snapshot else { return }
            guard let data = snap.data() else { return }
            let user = User(data: data)
            self.currentUser = user
            self.delegate?.currentUserUpdated()
            print("---CURRENT USER HANDLER: USER IS UPDATED FROM setCorrectUser()")
        }
    }
    
    private func getCurrentUser() {
        guard let userId = LogInHelper.getCurrentUserID() else { return }
        FirestoreHelper.getUser(userId: userId) { (snapshot, error) in
            if error != nil {
                print("GET USER ERROR: \(error!.localizedDescription)")
                return
            }
            guard let snap = snapshot else { return }
            guard let data = snap.data() else { return }
            let user = User(data: data)
            self.currentUser = user
            self.delegate?.currentUserUpdated()
            print("---CURRENT USER HANDLER: USER IS UPDATED FROM getCurrentUser()")
        }
    }
    
    
}
