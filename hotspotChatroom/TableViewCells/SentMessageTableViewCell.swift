//
//  SentMessageTableViewCell.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-26.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class SentMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chatBubbleView: UIView!
    
    func setMessageToCell(message: Message) {
        messageLabel.text = message.message
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBubbles()
    }
    
    func setUpBubbles() {
        chatBubbleView.layer.masksToBounds = false
        chatBubbleView.layer.cornerRadius = 18
        chatBubbleView.layer.shadowColor = UIColor.lightGray.cgColor
        chatBubbleView.layer.shadowOffset = CGSize.zero
        chatBubbleView.layer.shadowOpacity = 0.3
        chatBubbleView.layer.shadowRadius = 4
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
