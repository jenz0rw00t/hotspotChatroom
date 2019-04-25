//
//  ProfileViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-11.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startAuthListener()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    var currentUser: User?
    
    func setupCurrentUser() {
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
            self.setUserToUI()
        }
    }
    
    func setUserToUI() {
        usernameLabel.text = currentUser?.username
        emailLabel.text = currentUser?.email
    }
    
    func clearLabels() {
        usernameLabel.text = ""
        emailLabel.text = ""
    }
    
    // MARK: - viewWillAppear signed in listener
    
    var authListener: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authListener == nil {
            startAuthListener()
        }
        setupCurrentUser()
    }
    
    func startAuthListener() {
        authListener = LogInHelper.signedInListener { (auth, user) in
            if user == nil {
                self.tabBarController!.performSegue(withIdentifier: "signInSegue", sender: nil)
                self.clearLabels()
            }
        }
        setupCurrentUser()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogInHelper.removeSignInListener(listener: authListener!)
    }
    
    // MARK: - Button functions
    
    @IBAction func editUsernamePressed(_ sender: Any) {
        guard let user = currentUser else { return }
        
        let alert = UIAlertController(title: "Change Username", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = user.username
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            guard let newUsername = alert.textFields?.first?.text else { return }
            self.updateUsername(newUsername: newUsername)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func updateUsername(newUsername: String) {
        FirestoreHelper.updateUsername(userId: currentUser!.userId, userName: newUsername, completion: { (error) in
            if error != nil {
                Alert.showErrorAlert(on: self, error: error!)
                return
            }
            self.setupCurrentUser()
        })
    }
    
    @objc func handleLogOut() {
        Alert.showOneOptionAndCancelAlert(on: self, title: "Are you sure?", message: nil, buttonText: "Sign Out") { (_) in
            LogInHelper.signOutUser()
            self.tabBarController!.performSegue(withIdentifier: "signInSegue", sender: nil)
            self.clearLabels()
        }
    }

}
