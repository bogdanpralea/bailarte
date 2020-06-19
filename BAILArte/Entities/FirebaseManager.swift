//
//  Request.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 12/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class FirebaseManager {
    static let shared = FirebaseManager()
    
    var allVideos = [Video]()
    var premiumVideos = [Video]()
    var feedback = [String]()
    var categories = [Category]()
    var series = [Series]()
    var categoriesNumberOfVideos = [Int]()
    
    private init() {}
    
    func getData(success: @escaping (Bool) -> ()) {
        print("get data")
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
                    self.allVideos = model.videos
                    self.feedback = model.feedback
                    self.categories = model.categories
                    self.series = model.series
                    self.setCategoriesNumberOfVideos()
                    success(true)
                } else {
                    success(false)
                    print("Document does not exist")
                }
            case .failure(let error):
                success(false)
                print("Error decoding main model: \(error)")
            }
        }
    }
    
    func getPremiumData() {
        print("gett premium")
        let db = Firestore.firestore()
        let ref = db.collection("premium").document("9VNXFO0omaQQm2w0Sdwe")
        ref.getDocument { (snapshot, error) in
            let result = Result {
                try snapshot.flatMap {
                    try $0.data(as: PremiumModel.self)
                }
            }
            switch result {
            case .success(let mainModel):
                if let model = mainModel {
                    self.premiumVideos = model.videos
                    self.setPremiumVideos(premiumVideos: self.premiumVideos)
                    NotificationCenter.default.post(name: NSNotification.Name("ReloadMain"), object: nil)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding main model: \(error)")
            }
        }
    }
    
    func getAllVideos() -> [Video] {
        return allVideos
    }
    
    func getFeedback() -> [String] {
        return feedback
    }
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func getSeries() -> [Series] {
        return series
    }
    
    func getSeries(for category: Category) -> [Series] {
        return series.filter({$0.category == category.name})
    }
    
    func getVideos(for series: Series) -> [Video] {
        return allVideos.filter({$0.series == series.name})
    }
    
    func setCategoriesNumberOfVideos() {
        for (i, category) in categories.enumerated() {
            categoriesNumberOfVideos.insert(allVideos.filter({$0.category == category.name}).count, at: i)
        }
    }
    
    func setPremiumVideos(premiumVideos: [Video]) {
        for i in 0...premiumVideos.count - 1 {
            if let url = premiumVideos[i].url, let name = premiumVideos[i].name {
                if let index = allVideos.firstIndex(where: {($0.name?.contains(name) ?? false)}) {
                    allVideos[index].url = url
                }
            }
        }
    }

 }
