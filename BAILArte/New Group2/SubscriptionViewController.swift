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
    
    var productIdentifier = "one.month.test" //Get it from iTunes connect
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var products: [SKProduct] = []
    
    @IBOutlet var purchaseBttn: UIButton!
     @IBOutlet var restoreBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
            }
        }
//        if (SubscriptionTypes.store.isProductPurchased(SubscriptionTypes.monthlySub) ||
//            SubscriptionTypes.store.isProductPurchased(PoohWisdomProducts.yearlySub)){
        if (SubscriptionTypes.store.isProductPurchased(SubscriptionTypes.monthlySub)){
//          displayRandomQuote()
        } else {
          displayPurchaseQuotes()
        }
    }
    
 
    // MARK: - Displaying Quotes
    private func displayPurchaseQuotes() {
        print("purchased quote")
//      quoteLbl.text = "Wanna get random words of wisdom from Winnie the Pooh?\n\n" +
//                      "Press the 'Purchase' button!\nWhat are you waiting for?!"
    }

    private func purchaseItemIndex(index: Int) {
      SubscriptionTypes.store.buyProduct(products[index]) { [weak self] success, productId in
//        guard let self = self else { return }
         DispatchQueue.main.async {
        guard success else {
            
          let alertController = UIAlertController(title: "Failed to purchase product",
                                                  message: "Check logs for details",
                                                  preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertController, animated: true, completion: nil)
            
          return
        }
//        self?.displayRandomQuote()
        }
      }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionTableViewCell
//        cell.update(with: <#T##SubscriptionModel#>)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
    
    // MARK: - IBActions
    @IBAction func purchaseSubscription(_ sender: Any) {
      guard !products.isEmpty else {
        print("Cannot purchase subscription because products is empty!")
        return
      }

      let alertController = UIAlertController(title: "Choose your subscription",
                                              message: "Which subscription option works best for you",
                                              preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "Monthly",
                                              style: .default,
                                              handler: { action in
        self.purchaseItemIndex(index: 0)
      }))
      alertController.addAction(UIAlertAction(title: "Yearly",
                                              style: .default,
                                              handler: { action in
        self.purchaseItemIndex(index: 1)
      }))
      self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func restorePurchases(_ sender: Any) {
      SubscriptionTypes.store.restorePurchases()
    }
}
