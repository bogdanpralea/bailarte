//
//  Request.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 12/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import FirebaseFirestore

class Request {
    static let shared = Request()
    
    var allVideos = [Video]()
    var feedback = [String]()
    var categories = [Category]()
    var series = [Series]()
    var categoriesNumberOfVideos = [Int]()
    
    private init() {}
    
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
 }
