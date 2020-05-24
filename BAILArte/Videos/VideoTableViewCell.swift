//
//  VideoTableViewCell.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 12/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

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
        if let url = video.url {
//            genarateThumbnailFromYouTubeID(youTubeID: url)
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
    
    func genarateThumbnailFromYouTubeID(youTubeID: String) {
        let urlString = "http://img.youtube.com/vi/\(youTubeID)/1.jpg"
        let image = try! (UIImage(withContentsOfUrl: urlString))!
        thumbnailImageView.image = image
    }
    
}
