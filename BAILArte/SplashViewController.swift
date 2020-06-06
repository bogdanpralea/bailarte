//
//  SplashViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 22/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import AVKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class SplashViewController: UIViewController {
    
    var player = AVPlayer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        VimeoManager.shared.getVideoFromVimeo()
        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        playVideo()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
//            self.present(storyBoardName: "Main", controllerId: "LoginVC")
            self.present(storyBoardName: "Main", controllerId: "HomeId")
        })
    }
    
    private func getData() {
        let db = Firestore.firestore()
        let ref = db.collection("app").document("uGSYD14i9ZY90e5QkM3f")
        ref.getDocument { (snapshot, error) in
            let result = Result {
                try snapshot.flatMap {
                    try $0.data(as: MainModel.self)
                }
            }
            switch result {
            case .success(let mainModel):
                if let model = mainModel {
                    FirebaseManager.shared.allVideos = model.videos
                    FirebaseManager.shared.feedback = model.feedback
                    FirebaseManager.shared.categories = model.categories
                    FirebaseManager.shared.series = model.series
                    FirebaseManager.shared.setCategoriesNumberOfVideos()
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding main model: \(error)")
            }
        }
    }
    
    private func playVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient)
        } catch { }

        let path = Bundle.main.path(forResource: "bailarte", ofType:"mp4")

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

