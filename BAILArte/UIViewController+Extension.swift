//
//  UIViewController+Extension.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 22/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

extension UIViewController {

    func present(storyBoardName: String, controllerId: String) {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        var controller: UIViewController
        if #available(iOS 13.0, *) {
             controller = storyboard.instantiateViewController(identifier: controllerId)
        } else {
            // Fallback on earlier versions
             controller = storyboard.instantiateViewController(withIdentifier: controllerId)
        }
        controller.modalPresentationStyle = .fullScreen
//        let nav = UINavigationController(rootViewController: controller)
//        nav.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
    }
}
