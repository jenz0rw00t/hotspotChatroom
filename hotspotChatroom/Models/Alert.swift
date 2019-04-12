//
//  Alert.swift
//  hotspotChatroom
//
//  Created by Jens Sellén on 2019-03-25.
//  Copyright © 2019 Jens Sellén. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    static func showBasicOkAlert(on vc:UIViewController, title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showTwoOptionsAlert(on vc:UIViewController, title: String?, message: String?, button1: String, button2: String, completion1: ((UIAlertAction) -> Void)?, completion2: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: button1, style: .default, handler: completion1))
        alert.addAction(UIAlertAction(title: button2, style: .default, handler: completion2))
        vc.present(alert, animated: true)
    }
    
    static func showOneOptionAndCancelAlert(on vc:UIViewController, title: String?, message: String?, buttonText: String, completion: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: completion))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(alert, animated: true)
    }
    
    static func showErrorAlert(on vc:UIViewController, error:Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
    
    
}
