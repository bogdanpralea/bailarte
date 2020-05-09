//
//  Videos.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 12/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit

public struct Videos: Codable {
    var results: [Video]
}

//extension Videos: FirestoreModel {
//    var documentID: String! {
//        return ""
//    }
//
//    init?(modelData: FirestoreModelData) {
//        try? self.init(category: modelData.value(forKey: "category"), name: modelData.value(forKey: "name"), instructor: modelData.value(forKey: "instructor"), level: modelData.value(forKey: "level"), url: modelData.value(forKey: "url"))
//    }
//}
