//
//  SignInViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-10.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSpinner()
        
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text
        else { return }
        showSpinner()
        LogInHelper.signInUser(email: email, password: password) { (authResult, error) in
            if error != nil {
                print("SIGN IN ERROR: \(error!.localizedDescription)")
                Alert.showErrorAlert(on: self, error: error!)
                self.hideSpinner()
                return
            }
            self.hideSpinner()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Spinner funcions
    
    func showSpinner() {
        loadingSpinner.startAnimating()
        loadingSpinner.isHidden = false
    }
    
    func hideSpinner() {
        loadingSpinner.stopAnimating()
        loadingSpinner.isHidden = true
    }

}
