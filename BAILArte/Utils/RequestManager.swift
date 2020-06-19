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
    var firebaseConfigured = false

    func startRequests() {
        
        
        
        //        IAPManager.shared.expirationDateFor(<#T##identifier: String##String#>)
        if InternetConnectionManager.isConnectedToNetwork() {
            RequestManager.shared.noInternet = false
            
            getServerTimer { (serverDate) in
                if let date = UserDefaults.standard.object(forKey: "dateToCompare") as? Date {
                    print("date request:\(date)")
                }
                
                if let serverDate = serverDate as? Date {
                    print("date server:\(serverDate)")
                }
                
                if let date = UserDefaults.standard.object(forKey: "dateToCompare") as? Date, let serverDate = serverDate as? Date {
                    print("server: \(serverDate)")
                    if serverDate < date {
                        print("Activ Activ Activ Activ Activ Activ")
                        IAPManager.shared.subscriptionActiv = true
                    }
                    else {
                        IAPManager.shared.subscriptionActiv = false
                        FirebaseManager.shared.allVideos.removeAll()
                    }
                }
                else {
                    IAPManager.shared.refreshSubscriptionsStatus(callback: {
                        print("request manager refresh sucess")
                    }) { (error) in
                        print("request manager refresh fail")
                        IAPManager.shared.restorePurchases(success: {
                            print("resttore")
                            FirebaseManager.shared.getPremiumData()
                            IAPManager.shared.subscriptionActiv = true
                        }) { (error) in
                            print(error?.localizedDescription)
                        }
                    }
                    IAPManager.shared.subscriptionActiv = false
                    FirebaseManager.shared.allVideos.removeAll()
                }
            }

            NotificationCenter.default.post(name: NSNotification.Name("ReloadSubscription"), object: nil)
            
            VimeoManager.shared.vimeoAuthentication { (success) in
                if success { //there is internet
                    if !self.firebaseConfigured {
                        FirebaseApp.configure()
                        self.firebaseConfigured = true
                    }
                    
                    FirebaseManager.shared.getData { (success) in
                        if success {
                            if IAPManager.shared.subscriptionActiv {
                                FirebaseManager.shared.getPremiumData()
                            }
                            else {
                                NotificationCenter.default.post(name: NSNotification.Name("ReloadMain"), object: nil)
                            }
                        }
                    }
                }
            }
            
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        else {
            RequestManager.shared.noInternet = true 
        }
        
    }
    
    func getServerTimer(completion:@escaping (Date?)->()) {

        serverTimeReturn { date   -> Void in
            let dFormatter = ISO8601DateFormatter()
//            dFormatter.dateStyle = .long
//            dFormatter.timeStyle = .long
//            dFormatter.timeZone = TimeZone.current
            if let date = date {
                let dateGet = dFormatter.string(from: date)
                completion(date)
                print("server Formatted Time : \(dateGet)")
            } else {
                completion(nil)
            }
        }

    }

    func serverTimeReturn(completionHandler:@escaping (_ getResDate: Date?) -> Void) {

        let url = NSURL(string: "https://www.google.com")
        let task = URLSession.shared.dataTask(with: url! as URL) {(data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            if let contentType = httpResponse!.allHeaderFields["Date"] as? String {

                let dFormatter = DateFormatter()
//                let dFormatter = ISO8601DateFormatter()
                dFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
                dFormatter.locale = Locale(identifier: "en-US")
                if let serverTime = dFormatter.date(from: contentType) {
                    completionHandler(serverTime)
                } else {
                    completionHandler(nil)
                }
            }
        }

        task.resume()
    }
    
    
}
