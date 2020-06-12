//
//  SubscriptionTypes.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 15/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import Foundation

public struct SubscriptionTypes {
  public static let monthlySub = "one.month.test"
  public static let threeMonthSub = "three.months.test"
    public static let yearlySub = "one.year.test"
    public static let weeklySub = "one.week.test"
//  public static let yearlySub = "com.razeware.poohWisdom.yearlySub"
//  public static let store = IAPManager(productIDs: SubscriptionTypes.productIDs)
    public static let productIDs: Set<ProductID> = [SubscriptionTypes.weeklySub, SubscriptionTypes.monthlySub, SubscriptionTypes.threeMonthSub, SubscriptionTypes.yearlySub]
}

public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

