//
//  ChatViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-24.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatroom: Chatroom?
    var currentUser: User?
    var messages = [Message]()
    
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true

        startAuthListener()
        getCurrentUser()
        
        startChatListener()
        
        navigationItem.title = chatroom?.name
        sendButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))) 
    }
    
    // Om man varit inloggad på annat konto och går in i chat igen behövs tydligen detta
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.chatTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authListener == nil {
            startAuthListener()
        }
        if chatListener == nil {
            startChatListener()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogInHelper.removeSignInListener(listener: authListener!)
        chatListener?.remove()
    }
    
    // MARK: - IBActions
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        guard let user = currentUser else { return }
        guard let chatroomId = chatroom?.chatroomId else { return }
        let message = Message(username: user.username, userId: user.userId, message: messageTextField.text!, messageId: "", timestamp: Date())
        
        FirestoreHelper.addMessage(message: message, chatroomId: chatroomId) { (error) in
            if error != nil {
                print("ADD MESSAGE ERROR: \(error!.localizedDescription)")
            }
            self.chatTableView.reloadData()
        }
        messageTextField.text = nil
    }
    
    @IBAction func editingChangedInTextField(_ sender: UITextField) {
        guard let textCount = sender.text?.count else { return }
        if textCount > 0 {
            sendButton.isEnabled = true
        } else {
            sendButton.isEnabled = false
        }
    }
    
    // MARK: - Keyboard functions and animations
    
    @objc func dismissKeyboard() {
        messageTextField.endEditing(true)
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            
            let bottomSafeAreaHeight = getBottomSafeAreaHeight()
            
            bottomConstraint.constant = isKeyboardShowing ? -keyboardHeight+bottomSafeAreaHeight : 0
            
            animateWithKeyboard(isKeyboardShowing: isKeyboardShowing)
        }
    }
    
    func animateWithKeyboard(isKeyboardShowing: Bool) {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut , animations: {
            self.view.layoutIfNeeded()
        }) { (completed) in
            if isKeyboardShowing {
                if self.messages.count > 0 {
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
            
        }
    }
    
    func getBottomSafeAreaHeight() -> CGFloat {
        var bottomSafeAreaHeight: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows[0]
            let safeFrame = window.safeAreaLayoutGuide.layoutFrame
            bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
        }
        return bottomSafeAreaHeight
    }
    
    // MARK: - Chatlistener
    
    var chatListener: ListenerRegistration?
    
    func startChatListener() {
        guard let chatroomId = chatroom?.chatroomId else { return }
        chatListener = FirestoreHelper.chatSnapshotListener(chatroomId: chatroomId) { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {
                print("Error fetching messages: \(error!)")
                return
            }
            snapshot.documentChanges.forEach({ (diff) in
                if (diff.type == .added) {
                    if let message = Message(data: diff.document.data()) {
                        self.messages.append(message)
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.chatTableView.insertRows(at: [indexPath], with: .right)
                        self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                }
            })
//            self.chatTableView.reloadData()
//            let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
//            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - User and auth functions
    
    var authListener: AuthStateDidChangeListenerHandle?
    
    func startAuthListener() {
        authListener = LogInHelper.signedInListener { (auth, user) in
            if user == nil {
                print("----------USER IS NIL----------")
                self.tabBarController!.performSegue(withIdentifier: "signInSegueNoAnimation", sender: nil)
            } else if user?.uid != LogInHelper.getCurrentUserID() {
                print("----------USER IS NOT THE SAME?----------")
                self.currentUser = nil
            }
        }
    }
    
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
    
    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userId = currentUser?.userId
        let message = messages[indexPath.row]
        
        if userId == message.userId {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sentCell", for: indexPath) as! SentMessageTableViewCell
            cell.setMessageToCell(message: message)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "receivedCell", for: indexPath) as! ReceivedMessageTableViewCell
            cell.setMessageToCell(message: message)
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(messages[indexPath.row].message)
    }

}
