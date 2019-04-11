//
//  ProfileViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-11.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogOut))
        
    }
    
    @objc func handleLogOut() {
        Alert.showOneOptionAndCancelAlert(on: self, title: "Are you sure?", message: nil, buttonText: "Sign Out") { (_) in
            LogInHelper.signOutUser()
            self.tabBarController?.dismiss(animated: true, completion: nil)
        }
    }

}
