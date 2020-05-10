//
//  MainModel.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 11/04/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import Foundation

public struct MainModel: Codable {
    var categories: [Category]
    var feedback: [String]
    var videos: [Video]
    var series: [Series]
}
