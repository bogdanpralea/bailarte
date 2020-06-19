//
//  VimeoManager.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 06/06/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import VimeoNetworking
import Foundation

class VimeoManager: NSObject {

    static let shared = VimeoManager()
    
    
    func vimeoAuthentication(success: @escaping (Bool) -> ()) {
        let authenticationController = AuthenticationController(client: VimeoClient.defaultClient, appConfiguration: AppConfiguration.defaultConfiguration, configureSessionManagerBlock: nil)
        authenticationController.accessToken(token: VimeoClient.accessToken) { result in
            switch result
            {
            case .success(let account):
                 success(true)
                print("authenticated successfully: \(account)")
//                self.getVideoFromVimeo()
                
            case .failure(let error):
                success(false)
                if error.code == -1009 {
//                    RequestManager.shared.noInternet = true
                }
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

                case .failure(let error):
                    print("error retrieving video: \(error)")
                }
            }
        }
    }
    
    func getVideoFromVimeo(urlString: String) {
        let videoRequest = Request<VIMVideo>(path: "/videos/\(urlString)")
        DispatchQueue.global().async {
            
            //                let videoRequest = Request<[VIMVideo]>(path: "/me/videos")
            let _ = VimeoClient.defaultClient.request(videoRequest) { result in
                switch result {
                case .success(let response):
                    
                    let video = response.model
                    self.setVideoThumbnailAndLink(vimeoVideo: video)
                    
//                    if let file = video.files?.last as? VIMVideoFile {
//
//                        if let urlString = file.link {
//                        }
//
//                    }
                    
                case .failure(let error):
                    RequestManager.shared.noInternet = true 
                    print("error retrieving video: \(error)")
                }
            }
        }
    }
    
    func setVideosThumbnails(vimeoVideos: [VIMVideo]) {
        let videos = FirebaseManager.shared.getAllVideos()
        
        for i in 0...videos.count - 1 {
            if let url = videos[i].url {
                if let vimeoIndex = vimeoVideos.firstIndex(where: {($0.link?.contains(url) ?? false)}) {
                    let video = vimeoVideos[vimeoIndex]
                    if let file = video.files?.last as? VIMVideoFile, let urlString = file.link {
                        FirebaseManager.shared.allVideos[i].vimeoLink = urlString
                    }
                    
                    if let vimPicture = video.pictureCollection?.pictures?.last as? VIMPicture, let thumbnailUrlString = vimPicture.link {
                        FirebaseManager.shared.allVideos[i].thumbnail = thumbnailUrlString
                    }
                }
            }
        }
    }
    
    func setVideoThumbnailAndLink(vimeoVideo: VIMVideo) {
        let videos = FirebaseManager.shared.getAllVideos()
        
        for i in 0...videos.count - 1 {
            if let file = vimeoVideo.files?.last as? VIMVideoFile, let urlString = file.link, let url = videos[i].url  {
                
                if urlString.contains(url) {
                    var video = FirebaseManager.shared.allVideos[i]
                    video.vimeoLink = urlString
                    FirebaseManager.shared.allVideos[i].vimeoLink = urlString
                    
                    if let vimPicture = vimeoVideo.pictureCollection?.pictures?.last as? VIMPicture, let thumbnailUrlString = vimPicture.link {
                        FirebaseManager.shared.allVideos[i].thumbnail = thumbnailUrlString
                    }
                }
            }
            if i == videos.count - 1 {
                NotificationCenter.default.post(name: NSNotification.Name("ReloadTable"), object: nil)
            }
            
        }

    }
    
}
