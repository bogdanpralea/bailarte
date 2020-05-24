//
//  ClassCollectionViewCell.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 30/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class ClassCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func updateCell(with category: Category, nrOfVides: Int) {
        contentView.alpha = 0.9
        
//        var image = UIImage()
        
        if let picture = category.picture, !picture.isEmpty {
            let image = UIImage()
            imageView.image = image.convertBase64ToImage(imageString: picture)
        }
        
//        imageView.image = UI
        
//        if let urlString = "category.url" {
//            let url = URL(fileURLWithPath: urlString)
//            DispatchQueue.global().async {
//                guard let imageData = try? Data(contentsOf: url) else { return }
//
//                let image = UIImage(data: imageData)
//                DispatchQueue.main.async {
//                    self.imageView.image = image
//                }
//            }
//        }
        
        contentView.layer.cornerRadius = 10
        titleLabel.text = category.name
        countLabel.text = "\(nrOfVides) videos"
        
    }
}
