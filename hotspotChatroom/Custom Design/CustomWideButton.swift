//
//  CustomWideButton.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-30.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class CustomWideButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDesign()
    }
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                // IS ENABLE SHOW NORMAL BUTTON
                self.backgroundColor = #colorLiteral(red: 0.9107787013, green: 0.9611020684, blue: 0.9135276675, alpha: 1)
                self.alpha = 1
            } else {
                // IS NOT ENABLED SHOW GREY BUTTON
                self.backgroundColor = #colorLiteral(red: 0.7140747905, green: 0.7616125941, blue: 0.7174505591, alpha: 1)
                self.alpha = 0.7
            }
        }
    }

    func setDesign(){
        self.backgroundColor = #colorLiteral(red: 0.9107787013, green: 0.9611020684, blue: 0.9135276675, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .disabled)
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.masksToBounds = true
    }
}
