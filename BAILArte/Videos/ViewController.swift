//
//  ViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 22/03/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import YoutubePlayer_in_WKWebView

class ViewController: UIViewController {

    var urlString: String?

    @IBOutlet weak var playerView1: WKYTPlayerView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = urlString {
                   playerView1.load(withVideoId: url)
                   
//                   playerView1.playVideo()
               }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        playerView1.playVideo()

        self.tabBarController?.tabBar.isHidden = true
        
//        let value = UIInterfaceOrientation.landscapeLeft.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.myOrientation = .landscapeLeft
//        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.myOrientation = .portrait
//        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")

    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }

    override var shouldAutorotate: Bool {
        return true
    }
    

    

    func genarateThumbnailFromYouTubeID(youTubeID: String) {
           let urlString = "http://img.youtube.com/vi/\(youTubeID)/1.jpg"
           let image = try! (UIImage(withContentsOfUrl: urlString))!
       }
       
       func getThumbnailFromVideoUrl(urlString: String) {
           DispatchQueue.global().async {
               let asset = AVAsset(url: URL(string: urlString)!)
               let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
               assetImgGenerate.appliesPreferredTrackTransform = true
               let time = CMTimeMake(value: 1, timescale: 20)
               let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
               if img != nil {
                   let frameImg  = UIImage(cgImage: img!)
                   DispatchQueue.main.async(execute: {
                       // assign your image to UIImageView
                   })
               }
           }
       }
    

    

    
//    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
//        //  print(state)
//    }
//    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
//        //  print(playTime)
//    }
//    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        // print(playerView)
//    }
    
//    func extractYoutubeIdFromLink(link: String) -> String? {
//        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
//        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
//            return nil
//        }
//        let nsLink = link as NSString
//        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
//        let range = NSRange(location: 0, length: nsLink.length)
//        let matches = regExp.matches(in: link as String, options:options, range:range)
//        if let firstMatch = matches.first {
//            return nsLink.substring(with: firstMatch.range)
//        }
//        return nil
//    }
}

extension UIImage {
    convenience init?(withContentsOfUrl imageUrlString: String) throws {
        let imageUrl = URL(string: imageUrlString)!
        let imageData = try Data(contentsOf: imageUrl)
        
        self.init(data: imageData)
    }
    
}

//extension String {
//    var youtubeID: String? {
//        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
//
//        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
//        let range = NSRange(location: 0, length: count)
//
//        guard let result = regex?.firstMatch(in: self, range: range) else {
//            return nil
//        }
//
//        return (self as NSString).substring(with: result.range)
//    }
//
//}


//extension UINavigationController {
//
//override open var shouldAutorotate: Bool {
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.shouldAutorotate
//        }
//        return super.shouldAutorotate
//    }
//}
//
//override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.preferredInterfaceOrientationForPresentation
//        }
//        return super.preferredInterfaceOrientationForPresentation
//    }
//}
//
//override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
//    get {
//        if let visibleVC = visibleViewController {
//            return visibleVC.supportedInterfaceOrientations
//        }
//        return super.supportedInterfaceOrientations
//    }
//}}
