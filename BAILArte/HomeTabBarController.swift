//
//  HomeTabBarController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 10/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class HomeTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setTabBarColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    func setTabBarColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(hexString: "#0xFF6483").cgColor, UIColor(hexString: "#0xEB2253").cgColor]
        gradientLayer.locations = [0.0, 0.05]
        gradientLayer.type = .axial
        self.tabBar.layer.insertSublayer(gradientLayer, at: 0)
    }  
}
