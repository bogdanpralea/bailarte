//
//  SubscriptionViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 15/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noInternetStackView: UIStackView!
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var products: [SKProduct] = []
    var subscriptions: [SubscriptionModel] = []
    
    @IBOutlet var purchaseBttn: UIButton!
    @IBOutlet var restoreBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SubscriptionTypes.store.restorePurchases()
        SubscriptionTypes.store.requestProducts { [weak self] success, products in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard success else {
                    let alertController = UIAlertController(title: "Failed to load list of products",
                                                            message: "Check logs for details",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                self.products = products!
                self.mapSubscriptionModel(with: self.products)
                print()
            }
        }
//        if (SubscriptionTypes.store.isProductPurchased(SubscriptionTypes.monthlySub) ||
//            SubscriptionTypes.store.isProductPurchased(PoohWisdomProducts.yearlySub)){
        if (SubscriptionTypes.store.isProductPurchased(SubscriptionTypes.monthlySub)){
//          displayRandomQuote()
            print("purchased")
        } else {
          print("not purchased")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !RequestManager.shared.noInternet {
            noInternetView.isHidden = true
            noInternetStackView.isHidden = true 
        }
        
    }
    
    func mapSubscriptionModel(with models:[SKProduct]) {
        subscriptions.removeAll()
        for model in models {
            let subscription = SubscriptionModel(title: model.localizedTitle, monthlyPrice: "\(model.price)", totalPrice: "\(model.price)")
            subscriptions.append(subscription)
            tableview.reloadData()
        }
    }
 

   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionTableViewCell
        cell.update(with: subscriptions[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        purchaseSubscription(at: indexPath.row)
    }
    
    // MARK: - IBActions
    func purchaseSubscription(at index: Int) {
        guard !products.isEmpty else {
            print("Cannot purchase subscription because products is empty!")
            return
        }
        
        self.purchaseItemIndex(index: index)
    }
    
    private func purchaseItemIndex(index: Int) {
        SubscriptionTypes.store.buyProduct(products[index]) { [weak self] success, productId in
            guard let self = self else { return }
            DispatchQueue.main.async {
                guard success else {
                    
                    let alertController = UIAlertController(title: "Failed to purchase product",
                                                            message: "Check logs for details",
                                                            preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                    
                    return
                }
                //        self?.displayRandomQuote()
            }
        }
    }

    @IBAction func restorePurchases(_ sender: Any) {
      SubscriptionTypes.store.restorePurchases()
    }
}
