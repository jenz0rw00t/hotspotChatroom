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
    
    var loggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if loggedIn {
            performSegue(withIdentifier: "toTabSegue", sender: nil)
        }
    }
    
    var listener: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listener = LogInHelper.signedInListener { (auth, user) in
            if user != nil {
                print("-------USER IS LOGGED IN-------")
                self.performSegue(withIdentifier: "toTabSegue", sender: nil)
                self.loggedIn = true
            } else {
                print("-------USER IS NOT LOGGED IN-------")
                self.loggedIn = false
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        LogInHelper.removeSignInListener(listener: listener!)
    }
   

}
