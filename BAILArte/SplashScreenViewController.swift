//
//  SplashScreenViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 22/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SplashScreenViewController: UIViewController {
    
    var player = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func playSplashView() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "Video Path", ofType:"mp4")

        player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL)
        let playerLayer = AVPlayerLayer(player: player)

        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1

        self.view.layer.addSublayer(playerLayer)

        player.seek(to: CMTime.zero)
        player.play()
    }
}
