//
//  SubscriptionTableViewCell.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 23/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

protocol SubscriptionTableViewCellDelegate: class {
    func purchaseSubscription(_ subscriptionTableViewCell: SubscriptionTableViewCell, at index: Int)
}

class SubscriptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var purchaseButton: UIButton!
    @IBOutlet weak var activeButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var discountLabel: UILabel!
    
    weak var delegate: SubscriptionTableViewCellDelegate?
    var selectedIndex = -1
    var pricePerMonth = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with subscription: SubscriptionModel, at index: Int) {
        
        if selectedIndex == index {
            purchaseButton.isHidden = false
            activeButtonHeightConstraint.constant = 30
            backgroundImageView.layer.borderWidth = 1.0
            backgroundImageView.layer.borderColor = UIColor(hexString: "#0xFF6483").cgColor
        }
        else {
            purchaseButton.isHidden = true 
            activeButtonHeightConstraint.constant = 0
            backgroundImageView.layer.borderColor = UIColor.clear.cgColor
        }
        
        let attr32 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 32.0)]
        let attr24 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 24.0)]
        let attr16 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 16.0)]
        
        let price = NSMutableAttributedString(string: subscription.monthlyPrice!, attributes: attr32)
        let currency = NSMutableAttributedString(string: "RON", attributes: attr24)
        let month = NSMutableAttributedString(string: " / luna", attributes: attr16)
        
        let str = NSMutableAttributedString(string: "")
        str.append(price)
        str.append(currency)
        str.append(month)
        
        titleLabel.text = subscription.title
        monthlyPriceLabel.attributedText = str
        
        discountLabel.isHidden = index == 0
        discountLabel.text = "-\(getDiscount(from: subscription))%"
        totalPriceLabel.text = "Total de plata: " + subscription.totalPrice + " RON"
    }
    
    
    func getDiscount(from subscription: SubscriptionModel) -> Int {
        if let     monthlyPrice = subscription.monthlyPrice {
            let price = (Float(monthlyPrice)! * Float(100) / Float(pricePerMonth))
            return Int(100 - price)
        }
        else {
            return 0
        }
    }
    
    @IBAction func purchase(_ sender: UIButton){
        delegate?.purchaseSubscription(self, at: selectedIndex)
    }

}
