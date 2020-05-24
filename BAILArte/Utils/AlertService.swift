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
        
        let alertVC = storyboard.instantiateViewController(identifier: "AlertVC") as! AlertViewController
        alertVC.buttonActtion = completion
        
        return alertVC
    }
}
