//
//  VimeoManager.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 06/06/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import VimeoNetworking

class VimeoManager: NSObject {

    static let shared = VimeoManager()
    
    
    func vimeoAuthentication() {
        let authenticationController = AuthenticationController(client: VimeoClient.defaultClient, appConfiguration: AppConfiguration.defaultConfiguration, configureSessionManagerBlock: nil)
        authenticationController.accessToken(token: VimeoClient.accessToken) { result in
            switch result
            {
            case .success(let account):
                print("authenticated successfully: \(account)")
                self.getVideoFromVimeo()
                
            case .failure(let error):
                print("failure authenticating: \(error)")
            }
        }
    }
    
    func getVideoFromVimeo() {
        //        let videoRequest = Request<VIMVideo>(path: "/videos/\(urlString)")
        DispatchQueue.global().async {
            
            let videoRequest = Request<[VIMVideo]>(path: "/me/videos")
            let _ = VimeoClient.defaultClient.request(videoRequest) { result in
                switch result {
                case .success(let response):
                    
                    let videos = response.model
                    self.setVideosThumbnails(vimeoVideos: videos)
//                    print("videos:\(videos.count)")
//                    for video in videos {
//                        if let file = video.files?.last as? VIMVideoFile {
//
//                            print("link\(file.link)")
//                        }
//                    }
                    //                let video: VIMVideo =
                    //                let video: VIMVideo = response.model
//                                    if let file = video.files?.last as? VIMVideoFile {
//
//                                        if let urlString = file.link {
//                                            self.playVideo(from: urlString)
//                                        }
                    ////                    if let thumbnailUrlString = video.pictureCollection?.pictures?.first
                //                }
                case .failure(let error):
                    print("error retrieving video: \(error)")
                }
            }
        }
    }
    
    func setVideosThumbnails(vimeoVideos: [VIMVideo]) {
        //        let links = Set<String>(vimeoVideos.)
        let videos = FirebaseManager.shared.getAllVideos()
        
        for i in 0...videos.count - 1 {
            if let url = videos[i].url {
                if let vimeoIndex = vimeoVideos.firstIndex(where: {($0.link?.contains(url) ?? false)}) {
                    let video = vimeoVideos[vimeoIndex]
//                    if let file = video.files?.last as? VIMVideoFile {
                        
                    if let vimPicture = video.pictureCollection?.pictures?.last as? VIMPicture, let thumbnailUrlString = vimPicture.link {
                        FirebaseManager.shared.allVideos[i].thumbnail = thumbnailUrlString
                        }
//                    }
                }
            }
        }
    }
    
}