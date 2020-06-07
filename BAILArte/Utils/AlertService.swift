//
//  AlertService.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 22/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class AlertService {

    func alert(completion: @escaping () -> Void) -> AlertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        var alertVC: AlertViewController
        if #available(iOS 13.0, *) {
             alertVC = storyboard.instantiateViewController(identifier: "AlertVC") as! AlertViewController
        } else {
            // Fallback on earlier versions
             alertVC = storyboard.instantiateViewController(withIdentifier: "AlertVC") as! AlertViewController
        }
        
        alertVC.buttonActtion = completion
        
        return alertVC
    }
    
    func simpleAlert(completion: @escaping () -> Void) -> SimpleAlertViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        var alertVC: SimpleAlertViewController
        if #available(iOS 13.0, *) {
            alertVC = storyboard.instantiateViewController(identifier: "SimpleAlertVC") as! SimpleAlertViewController
        } else {
            // Fallback on earlier versions
             alertVC = storyboard.instantiateViewController(withIdentifier: "SimpleAlertVC") as! SimpleAlertViewController
        }
        alertVC.buttonActtion = completion
        
        return alertVC
    }
}


