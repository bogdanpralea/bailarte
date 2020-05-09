//
//  Categories.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 11/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

public struct Categories: Codable {
    var results: [Category]
    
//    public init(name: String? = nil, picture: String? = nil) {
//        self.name = name
//        self.picture = picture
//    }
}

//extension Categories: FirestoreModel {
//    var documentID: String! {
//        return ""
//    }
//
//    init?(modelData: FirestoreModelData) {
//        try? self.init(name: modelData.value(forKey: "name"), picture: modelData.value(forKey: "picture"))
//    }
//}
