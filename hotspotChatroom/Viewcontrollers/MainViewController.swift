//
//  MainViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-10.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    @IBAction func signOutPressed(_ sender: Any) {
        Alert.showOneOptionAndCancelAlert(on: self, title: "Are you sure?", message: nil, buttonText: "Sign Out") { (_) in
            LogInHelper.signOutUser()
            self.performSegue(withIdentifier: "signInSegue", sender: nil)
        }
    }
    
    var listener: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener = LogInHelper.signedInListener { (auth, user) in
            if user != nil {
                print("-------USER IS LOGGED IN-------")
            } else {
                print("-------USER IS NOT LOGGED IN-------")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
        
        if let currentUserID = LogInHelper.getCurrentUserID() {
            welcomeLabel.text = "Welcome, \(currentUserID)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogInHelper.removeSignInListener(listener: listener!)
    }
   

}
