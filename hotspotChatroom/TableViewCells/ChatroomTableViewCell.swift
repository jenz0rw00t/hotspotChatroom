//
//  ChatroomTableViewCell.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-20.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class ChatroomTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var creatorLabel: UILabel!
    
    func setChatroomToCell(chatroom: Chatroom) {
        nameLabel.text = chatroom.name
        creatorLabel.text = "Created by: \(chatroom.creatorUsername)"
    }
}
