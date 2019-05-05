//
//  ReceivedMessageTableViewCell.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-26.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class ReceivedMessageTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chatBubbleView: UIView!
    @IBOutlet weak var timestampLabel: UILabel!
    
    func setMessageToCell(message: Message) {
        let timestamp = formatDate(date: message.timestamp)
        usernameLabel.text = "\(message.username):"
        messageLabel.text = message.message
        timestampLabel.text = timestamp
    }
    
    func setSameUsernameMessage(message: Message) {
        let timestamp = formatDate(date: message.timestamp)
        usernameLabel.text = nil
        messageLabel.text = message.message
        timestampLabel.text = timestamp
        layoutIfNeeded()
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
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        let isToday = Calendar.current.isDateInToday(date)
        let isYesterday = Calendar.current.isDateInYesterday(date)

        var dateString = ""
        
        if isToday {
            dateFormatter.dateFormat = "HH:mm"
            dateString = dateFormatter.string(from: date)
        } else if isYesterday {
            dateFormatter.dateFormat = "HH:mm"
            dateString = "Yesterday, \(dateFormatter.string(from: date))"
        } else {
            dateFormatter.dateFormat = "E dd/MM"
            dateString = dateFormatter.string(from: date)
        }
        return dateString
    }

}
