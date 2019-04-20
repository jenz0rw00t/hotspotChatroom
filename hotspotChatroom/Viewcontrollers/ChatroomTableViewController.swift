//
//  ChatroomTableViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-12.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatroomTableViewController: UITableViewController {
    
    var chatrooms = [Chatroom]()
    var currentUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        getCurrentUser()
        startChatroomListener()
        
    }
    
    // MARK: - IBActions
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        createChatroomAlert()
        
        
    }
    
    // MARK: - Functions
    
    func getCurrentUser() {
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
        }
    }
    
    func createChatroomAlert() {
        
        let alert = UIAlertController(title: "Create a new Chatroom", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Chatroom name..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            guard let chatroomName = alert.textFields?.first?.text else { return }
            guard let currentUsername = self.currentUser?.username else { return }
            let chatroom = Chatroom(name: chatroomName, creatorUsername: currentUsername, chatroomId: "")
            self.createChatroom(chatroom: chatroom)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func createChatroom(chatroom: Chatroom) {
        FirestoreHelper.addChatroom(chatroom: chatroom) { (error) in
            if error != nil {
                print("ADD CHATROOM ERROR: \(error!.localizedDescription)")
            }
        }
    }
    
    func startChatroomListener() {
        FirestoreHelper.chatroomSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error!)")
                return
            }
            self.chatrooms.removeAll()
            for document in documents {
                if let chatroom = Chatroom(data: document.data()) {
                    self.chatrooms.append(chatroom)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    // MARK: - viewWillAppear signed in listener
    
    var listener: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener = LogInHelper.signedInListener { (auth, user) in
            if user == nil {
                self.tabBarController!.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogInHelper.removeSignInListener(listener: listener!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatrooms.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatroomCell", for: indexPath) as! ChatroomTableViewCell

        cell.setChatroomToCell(chatroom: chatrooms[indexPath.row])

        return cell
    }
    

    

}
