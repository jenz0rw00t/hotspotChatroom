//
//  ChatTableViewCell.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-25.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chatbubbleView: UIView!
    @IBOutlet weak var sentChatbubbleView: UIView!
    @IBOutlet weak var sentMessageLabel: UILabel!
    
    func setMessageToCell(message: Message) {
        sentChatbubbleView.isHidden = true
        usernameLabel.text = message.username
        messageLabel.text = message.message
    }
    
    func setSentMessageToCell(message: Message) {
        usernameLabel.isHidden = true
        chatbubbleView.isHidden = true
        sentMessageLabel.text = message.message
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
