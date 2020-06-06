//
//  SimpleAlertViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 01/06/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class SimpleAlertViewController: UIViewController {

    var buttonActtion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func goToAbonamente(_ sender: UIButton) {
        dismiss(animated: true)
        buttonActtion?()
    }

}
