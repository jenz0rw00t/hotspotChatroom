//
//  ChatViewController.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-24.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chatroom: Chatroom?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
     
        // Configure the cell...
        if indexPath.row == 3 {
            cell.chatbubbleView.isHidden = true
            cell.usernameLabel.isHidden = true
            cell.sentMessageLabel.text = "Hej här har jag skrivit något själv"
        } else if indexPath.row == 5 {
            cell.usernameLabel.text = "Coola killen kalle-cool!"
            cell.messageLabel.text = "!"
            cell.sentChatbubbleView.isHidden = true
        } else {
            cell.messageLabel.text = "Hej vad händer om jag kör massa grejer här och hur byter den rad och allt sånt det blir spännande att se!"
            cell.sentChatbubbleView.isHidden = true
        }
     
        return cell
    }
 

}
