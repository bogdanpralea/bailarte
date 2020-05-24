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
        titleLabel.text = subscription.title
        monthlyPriceLabel.text = subscription.monthlyPrice
        totalPriceLabel.text = subscription.totalPrice
    }

}
