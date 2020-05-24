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
//  public static let yearlySub = "com.razeware.poohWisdom.yearlySub"
  public static let store = IAPManager(productIDs: SubscriptionTypes.productIDs)
  private static let productIDs: Set<ProductID> = [SubscriptionTypes.monthlySub]
}

public func resourceNameForProductIdentifier(_ productIdentifier: String) -> String? {
  return productIdentifier.components(separatedBy: ".").last
}

