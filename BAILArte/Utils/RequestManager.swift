//
//  RequestManager.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 07/06/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import Foundation
import Reachability
import VimeoNetworking
import Firebase
import Network

class RequestManager {
    
    static let shared = RequestManager()
    
    var noInternet = false
    let monitor = NWPathMonitor()
    var firebaseConfigured = false
    
//    func isInternet() -> Bool {
//        let reachability = try! Reachability()
//
//        reachability.whenReachable = { reachability in
//            if reachability.connection == .wifi {
//                print("Reachable via WiFi")
//                return true
//            } else {
//                print("Reachable via Cellular")
//                return true
//            }
//        }
//        reachability.whenUnreachable = { _ in
//            print("Not reachable")
//            return false
//        }
//
//        do {
//            try reachability.startNotifier()
//        } catch {
//            print("Unable to start notifier")
//        }
//        
//        return false
//    }
    
    func startRequests() {
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("We're connected!")
//                self.noInternet = false
//
                if !self.firebaseConfigured {
                    FirebaseApp.configure()
                    self.firebaseConfigured = true
                }
//
////                DispatchQueue.main.async {
                    FirebaseManager.shared.getData()
                    VimeoManager.shared.vimeoAuthentication()
                    
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
////                }
//
//            } else {
//                print("No connection.")
//                self.noInternet = true
//            }

//        }
        
   
    }
    
//    func startMonitorInternetConnection() {
//        let queue = DispatchQueue(label: "Monitor")
////        monitor.start(queue: queue)
//    }
    
//    func isInternet() {
//
//        monitor.pathUpdateHandler = { path in
//            if path.status == .satisfied {
//                print("We're connected!")
//            } else {
//                print("No connection.")
//            }
//
//            print(path.isExpensive)
//        }
//    }
}
