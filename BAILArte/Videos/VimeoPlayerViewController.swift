//
//  VimeoPlayerViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 11/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
//import PlayerKit
import AVFoundation
import VimeoNetworking
import WebKit
import AVKit

class VimeoPlayerViewController: UIViewController {

    var videos: [VIMVideo] = []
    {
        didSet
        {
            print("videos:\(videos[0].uri)")
//            webView.load(URLRequest(url: URL(string: videos[0].uri!)!))
//            self.tableView.reloadData()
        }
    }
    
    @IBOutlet  var webView: WKWebView!
    
    private var accountObservationToken: ObservationToken?
    
//    private let player = RegularPlayer()
    @IBOutlet weak var playerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let player = RegularPlayer()
//
//        view.addSubview(player.view) // RegularPlayer conforms to `ProvidesView`, so we can add its view

//        player.delegate = self

        
        addPlayerToView()
        
  
//        player.set(AVURLAsset(url: URL(string: "/me/videos/id/me/videos/413705334")!))
        
        let authenticationController = AuthenticationController(client: VimeoClient.defaultClient, appConfiguration: AppConfiguration.defaultConfiguration, configureSessionManagerBlock: nil)
        authenticationController.accessToken(token: VimeoClient.accessToken) { result in
            switch result
            {
                case .success(let account):
                    print("result:\(result)")
                    print("authenticated successfully: \(account)")

//                    self.setupAccountObservation()
                case .failure(let error):
                   print("failure authenticating: \(error)")
            }
        }
    }
    
    func codeGrantLogin() {

        
    }
    
    private func addPlayerToView() {
//        player.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        player.view.frame = playerView.bounds
////        self.view.insertSubview(player.view, at: 0)
//        playerView.addSubview(player.view)
//        player.play()
        
    }
    
    private func setupAccountObservation()
    {
        // This allows us to fetch a new list of items whenever the current account changes (on log in or log out events)
        
//        self.accountObservationToken = NetworkingNotification.authenticatedAccountDidChange.observe { [weak self] notification in
//
//            guard let strongSelf = self else
//            {
//                return
//            }
            
        let videoRequest = Request<VIMVideo>(path: "/videos/419068453")
//        let videoRequest = Request<VIMVideo>(path: "/videos/419068453")
       let _ = VimeoClient.defaultClient.request(videoRequest) { result in
            switch result {
            case .success(let response):
//                let video: VIMVideo = response.model
                 let video: VIMVideo = response.model
                 if let file = video.files?.last as? VIMVideoFile {
                 
                print("retrieved video: \(video)")
//                self.webView.load(URLRequest(url: URL(string: video.link!)!))
//                 self.player.set(AVAsset(url: URL(string: file.link!)!))
                    let player = AVPlayer(url: URL(string: file.link!)!)
                    let vc = AVPlayerViewController()
                    vc.player = player

                    self.present(vc, animated: true) {
                        vc.player?.play()
                    }
                }
            case .failure(let error):
                print("error retrieving video: \(error)")
            }
        }
        
//            let request: Request<[VIMVideo]>
//            if VimeoClient.defaultClient.currentAccount?.isAuthenticatedWithUser() == true
//            {
//                request = Request<[VIMVideo]>(path: "/me/videos")
//            }
//            else
//            {
//                request = Request<[VIMVideo]>(path: "/channels/staffpicks/videos")
//            }
//
//            let _ = VimeoClient.defaultClient.request(request) { [weak self] result in
//
//                guard let strongSelf = self else
//                {
//                    return
//                }
//
//                switch result
//                {
//                case .success(let response):
//
//                    strongSelf.videos = response.model
//
//                    if let nextPageRequest = response.nextPageRequest
//                    {
//                        print("starting next page request")
//
//                        let _ = VimeoClient.defaultClient.request(nextPageRequest) { [weak self] result in
//
//                            guard let strongSelf = self else
//                            {
//                                return
//                            }
//
//                            if case .success(let response) = result
//                            {
//                                print("next page request completed!")
//                                strongSelf.videos.append(contentsOf: response.model)
////                                strongSelf.tableView.reloadData()
//                            }
//                        }
//                    }
//                case .failure(let error):
//                    let title = "Video Request Failed"
//                    let message = "\(request.path) could not be loaded: \(error.localizedDescription)"
//                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                    alert.addAction(action)
//                    strongSelf.present(alert, animated: true, completion: nil)
//                }
//            }
            
//        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        print("play")
//        player.play()
    }

}
