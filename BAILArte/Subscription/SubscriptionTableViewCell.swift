//
//  SubscriptionTableViewCell.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 23/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class SubscriptionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(with subscription: SubscriptionModel) {
        let attr32 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 32.0)]
        let attr24 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 24.0)]
        let attr16 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 16.0)]
        
        let price = NSMutableAttributedString(string: subscription.monthlyPrice, attributes: attr32)
        let currency = NSMutableAttributedString(string: "RON", attributes: attr24)
        let month = NSMutableAttributedString(string: " / luna", attributes: attr16)
        
        let str = NSMutableAttributedString(string: "")
        str.append(price)
        str.append(currency)
        str.append(month)
        
        titleLabel.text = subscription.title
        monthlyPriceLabel.attributedText = str

        totalPriceLabel.text = "Total de plata: " + subscription.totalPrice + " RON"
    }

}
