//
//  VideoTableViewCell.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 12/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructorLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func update(with video: Video) {
        titleLabel.text = video.name
        instructorLabel.text = video.instructor
        levelLabel.text = video.level
        
        thumbnailImageView.layer.borderColor = UIColor(hexString: "7B72DE").cgColor
        if let url = video.thumbnail {

                // just not to cause a deadlock in UI!
            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: URL(string: url)!) else { return }

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                }
            }
        }
        else {
            thumbnailImageView.image = UIImage(named: "lock.pdf")
        }
    }
    
    func update(with series: Series) {
        titleLabel.text = series.name
        instructorLabel.text = series.category
        if let picture = series.picture, !picture.isEmpty {
            let image = UIImage()
            thumbnailImageView?.image = image.convertBase64ToImage(imageString: picture)
        }
        
        thumbnailImageView.layer.borderColor = UIColor(hexString: "7B72DE").cgColor
       
    }
    

    
}
