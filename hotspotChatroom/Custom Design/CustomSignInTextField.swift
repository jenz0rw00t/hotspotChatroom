//
//  CustomSignInTextField.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-04-30.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import UIKit

class CustomSignInTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDesign()
    }

    func setDesign(){
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        layer.masksToBounds = true
    }
    
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
            CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
            CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
}
