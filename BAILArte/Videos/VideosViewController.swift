//
//  VideosViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 04/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import GoogleMobileAds

class VideosViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var videos = [Video]()
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
                
//        navigationController?.navigationBar.isHidden = false
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//               appDelegate.myOrientation = .portrait
//               UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = false
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//               appDelegate.myOrientation = .portrait
//               UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
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
        if interstitial.isReady {
          interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }
    
    func goToPlayer(at index: Int) {
        guard let vc = storyboard?.instantiateViewController(identifier: "PlayerVC") as? ViewController else { return }
        
        vc.urlString = videos[index].url
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
      print("interstitialDidDismissScreen")
        if let index = tableView.indexPathsForSelectedRows?.first {
            goToPlayer(at: index.row)
        }
    }

    
    
    @IBAction func dismissView(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
