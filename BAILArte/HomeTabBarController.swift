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

        // Do any additional setup after loading the view.
        setTabBarColor()
//        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tabbar appear")
    }
    
//    func getData() {
//        let db = Firestore.firestore()
//        let ref = db.collection("app").document("uGSYD14i9ZY90e5QkM3f")
//        ref.getDocument { (snapshot, error) in
//            let result = Result {
//                try snapshot.flatMap {
//                    try $0.data(as: MainModel.self)
//                }
//            }
//            switch result {
//            case .success(let mainModel):
//                if let model = mainModel {
//                    Request.shared.allVideos = model.videos
//                    Request.shared.feedback = model.feedback
//                    Request.shared.categories = model.categories
//                } else {
//                    print("Document does not exist")
//                }
//            case .failure(let error):
//                print("Error decoding main model: \(error)")
//            }
//        }
//    }
    

    func setTabBarColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(hexString: "#0xFF6483").cgColor, UIColor(hexString: "#0xEB2253").cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0.0, 0.05]
        gradientLayer.type = .axial
        self.tabBar.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
}
