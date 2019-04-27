//
//  ProfileViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-11.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController, CurrentUserHandlerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var currentUser: User? {
        didSet {
            setUserToUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrentUserHandler.shared.delegate = self
        currentUser = CurrentUserHandler.shared.currentUser
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentUser = CurrentUserHandler.shared.currentUser
    }
    
    func updateUsername(newUsername: String) {
        guard let userId = currentUser?.userId else { return }
        FirestoreHelper.updateUsername(userId: userId, userName: newUsername, completion: { (error) in
            if error != nil {
                Alert.showErrorAlert(on: self, error: error!)
                return
            }
            CurrentUserHandler.shared.updateUser()
        })
    }
    
    // MARK: - UI Setup functions
    
    func setUserToUI() {
        usernameLabel.text = currentUser?.username
        emailLabel.text = currentUser?.email
    }
    
    func clearLabels() {
        usernameLabel.text = ""
        emailLabel.text = ""
    }
    
    // MARK: - Button functions and IBActions
    
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
    
    @objc func handleLogOut() {
        Alert.showOneOptionAndCancelAlert(on: self, title: "Are you sure?", message: nil, buttonText: "Sign Out") { (_) in
            CurrentUserHandler.shared.signOut()
            self.tabBarController!.performSegue(withIdentifier: "signInSegue", sender: nil)
            self.clearLabels()
        }
    }
    
    func currentUserUpdated() {
        currentUser = CurrentUserHandler.shared.currentUser
    }

}
