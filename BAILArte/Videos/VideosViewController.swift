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
    var selectedIndex = 0
    var selectedSeries: Series?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable), name: NSNotification.Name(rawValue: "ReloadTable"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
//        RequestManager.shared.checkInternet()
        
        if !InternetConnectionManager.isConnectedToNetwork() {
            navigationController?.popToRootViewController(animated: true)
            return 
        }
                
        for i in 0...videos.count - 1 {
            if let url = videos[i].url, url != "", videos[i].vimeoLink == nil {
                
                VimeoManager.shared.getVideoFromVimeo(urlString: url)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver("ReloadTable")
    }
    
    @objc func reloadTable() {
        if let series = selectedSeries {
            videos = FirebaseManager.shared.getVideos(for: series)
            tableView.reloadData()
        }
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
        selectedIndex = indexPath.row
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
            if IAPManager.shared.subscriptionActiv {
                print("activ")
                self.goToSelectedVideo()
            } else {
                print("nnot activ")
                let alert = alertservice.alert() { [weak self] in
                    self?.tabBarController?.selectedIndex = 3
                }

                present(alert, animated: true)
            }
        }
    }

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        goToSelectedVideo()
    }
    
    func goToSelectedVideo() {
        if let urlString = videos[selectedIndex].vimeoLink {
            playVideo(from: urlString)
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
