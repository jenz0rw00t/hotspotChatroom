//
//  SignUpViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-10.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: CustomSignInTextField!
    @IBOutlet weak var emailTextField: CustomSignInTextField!
    @IBOutlet weak var passwordTextField: CustomSignInTextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.setIcon(#imageLiteral(resourceName: "baseline_person_black_24pt_1x"))
        emailTextField.setIcon(#imageLiteral(resourceName: "message"))
        passwordTextField.setIcon(#imageLiteral(resourceName: "lock"))
        
        signUpButton.isEnabled = false
        hideSpinner()
        usernameTextField.becomeFirstResponder()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    // Keyboard handling
    
    @objc func dismissKeyboard() {
        usernameTextField.endEditing(true)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
    }
    
    // MARK: - IBActions
    
    @IBAction func editingChangedInPasswordOrUsername(_ sender: Any) {
        if passwordTextField.text!.count > 5 && usernameTextField.text!.count > 1 {
            signUpButton.isEnabled = true
        } else {
            signUpButton.isEnabled = false
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            let username = usernameTextField.text
        else { return }
        
        dismissKeyboard()
        showSpinner()
        
        LogInHelper.signUpUser(email: email, password: password) { (authResult, error) in
            if error != nil {
                Alert.showErrorAlert(on: self, error: error!)
                self.hideSpinner()
                return
            }
            guard let result = authResult else { return }
            
           let user = User(userId: result.user.uid, email: result.user.email!, username: username)
            
            FirestoreHelper.addUser(user: user, completion: { (error) in
                if error != nil {
                    Alert.showErrorAlert(on: self, error: error!)
                    self.hideSpinner()
                    return
                }
                print("New user created and added to database!")
                self.hideSpinner()
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismissKeyboard()
        dismiss(animated: true, completion: nil)
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
