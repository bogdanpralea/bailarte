//
//  VideosViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 04/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation
import VimeoNetworking
import AVKit

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [Video]()
    var interstitial: GADInterstitial!
    let alertservice = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        
        cell.update(with: videos[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        if let _ = video.url {
            if interstitial.isReady {
                interstitial.present(fromRootViewController: self)
            } else {
                print("Ad wasn't ready")
                goToSelectedVideo()
            }
        }
        else {
            let alert = alertservice.alert() { [weak self] in
                self?.tabBarController?.selectedIndex = 3
            }
            
            present(alert, animated: true)
        }
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        goToSelectedVideo()
    }
    
    func goToSelectedVideo() {
        if let index = tableView.indexPathsForSelectedRows?.first {
            if let urlString = videos[index.row].url {
                getVideoFromVimeo(for: urlString)
            }
        }
    }
    
    
    func getVideoFromVimeo(for urlString: String) {
//        let videoRequest = Request<VIMVideo>(path: "/videos/\(urlString)")
        let videoRequest = Request<[VIMVideo]>(path: "/me/videos")
        let _ = VimeoClient.defaultClient.request(videoRequest) { result in
            switch result {
            case .success(let response):
                
                let videos = response.model
                print("")
//                let video: VIMVideo =
//                let video: VIMVideo = response.model
//                if let file = video.files?.last as? VIMVideoFile {
//
//                    if let urlString = file.link {
//                        self.playVideo(from: urlString)
//                    }
////                    if let thumbnailUrlString = video.pictureCollection?.pictures?.first
//                }
            case .failure(let error):
                print("error retrieving video: \(error)")
            }
        }
    }
    
    func playVideo(from urlString: String) {
        let player = AVPlayer(url: URL(string: urlString)!)
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
