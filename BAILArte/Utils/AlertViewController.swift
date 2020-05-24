//
//  AlertViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 22/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {

    var buttonActtion: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    @IBAction func goToAbonamente(_ sender: UIButton) {
        dismiss(animated: true)
        buttonActtion?()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        dismiss(animated: true)
    }

}
