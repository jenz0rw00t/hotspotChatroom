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
        usernameLabel.text = message.username
        messageLabel.text = message.message
        timestampLabel.text = timestamp
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpBubbles()
    }
    
    func setUpBubbles() {
        chatBubbleView.layer.masksToBounds = true
        chatBubbleView.layer.cornerRadius = 15
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
            dateString = "Yesterday:\(dateFormatter.string(from: date))"
        } else {
            dateFormatter.dateFormat = "E dd/MM/yyyy"
        }
        
        return dateString
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
