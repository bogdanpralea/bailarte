//
//  SubscriptionViewController.swift
//  BAILArte
//
//  Created by Bogdan Pralea on 15/05/2020.
//  Copyright © 2020 Pralea. All rights reserved.
//

import UIKit
import StoreKit

class SubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SubscriptionTableViewCellDelegate {
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var noInternetView: UIView!
    @IBOutlet weak var noInternetStackView: UIStackView!
    @IBOutlet weak var subscriptionView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var subscriptionTitleLabel: UILabel!
    @IBOutlet weak var subscriptionPriceLabel: UILabel!
    @IBOutlet weak var subscriptionDateLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var products: [SKProduct] = []
    var subscriptions: [SubscriptionModel] = []
    var selectedIndex = -1
    var pricePerMonth = 0.0
    
    @IBOutlet var purchaseBttn: UIButton!
    @IBOutlet var restoreBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: Notification.Name("ReloadSubscription"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: IAP_PRODUCTS_DID_LOAD_NOTIFICATION, object: nil)

        tableview.rowHeight = UITableView.automaticDimension
        tableview.estimatedRowHeight = 100
        
        tableview.sectionHeaderHeight = UITableView.automaticDimension
        tableview.estimatedSectionHeaderHeight = 70

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if InternetConnectionManager.isConnectedToNetwork() {
            noInternetView.isHidden = true
            noInternetStackView.isHidden = true 
        }
    }
    
    @objc func reloadData() {
        print("reloadData subscriptionn")
        if InternetConnectionManager.isConnectedToNetwork() {
            if subscriptions.count == 0 {
                IAPManager.shared.startWith(arrayOfIds: SubscriptionTypes.productIDs)
            }
            
//            if IAPManager.shared.subscriptionActiv {
            let productIds = [SubscriptionTypes.weeklySub, SubscriptionTypes.monthlySub, SubscriptionTypes.threeMonthSub, SubscriptionTypes.yearlySub]
            
            if let productId = UserDefaults.standard.object(forKey: "id"), let date = UserDefaults.standard.object(forKey: "date"), subscriptions.count > 0 && IAPManager.shared.subscriptionActiv {
                
                let index = productIds.firstIndex(of: productId as! String) ?? 0
                let product = subscriptions[index]
                
                
                let attr32 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 32.0)]
                let attr24 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 24.0)]
                let attr16 = [NSAttributedString.Key.font: UIFont(name: "Roboto-Medium", size: 16.0)]
                
                let price = NSMutableAttributedString(string: product.monthlyPrice!, attributes: attr32)
                let currency = NSMutableAttributedString(string: "RON", attributes: attr24)
                let month = NSMutableAttributedString(string: " / luna", attributes: attr16)
                
                let str = NSMutableAttributedString(string: "")
                str.append(price)
                str.append(currency)
                str.append(month)
                
                subscriptionTitleLabel.text = product.title
                subscriptionPriceLabel.attributedText = str
                subscriptionDateLabel.text = "Valabil pana la: \(date)"
                
                subscriptionView.isHidden = false
                titleView.isHidden = true
                backgroundImageView.layer.borderWidth = 1
                backgroundImageView.layer.borderColor = UIColor(hexString:"554DD0").cgColor
            } else {
                subscriptionView.isHidden = true
                titleView.isHidden = false
            }
            tableview.reloadData()
        }
    }
    
    @objc func loadData() {
        if let products = IAPManager.shared.products {
          
            var sortedModels = products
                sortedModels.sort {
                    $0.price.compare($1.price) == ComparisonResult.orderedAscending
            }
            
            self.products = sortedModels
            mapSubscriptionModel(with: sortedModels)
            reloadData()
            tableview.reloadData()
        }
    }
    
    
    func mapSubscriptionModel(with models:[SKProduct]) {
        subscriptions.removeAll()
        for i in 0...models.count - 1 {
            let model = models[i]
//            let period = model.subscriptionPeriod?.numberOfUnits ?? 0
            let period = i == 0 ? 1 : i == 1 ? 3 : 12
            let subscription = SubscriptionModel(title: model.localizedTitle, monthlyPrice: String(format: "%.2f", (Float(model.price) / Float(period))), totalPrice: String(format: "%.2f", Float(model.price)), period: period, price: Float(model.price))
            subscriptions.append(subscription)
            
        }
        
        if let firstPrice = subscriptions.first?.price {
            pricePerMonth = Double(firstPrice)
        }
        tableview.reloadData()
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        
        return v
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return IAPManager.shared.subscriptionActiv ? 0 : subscriptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell", for: indexPath) as! SubscriptionTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.selectedIndex = selectedIndex
        cell.pricePerMonth = pricePerMonth
        
        cell.update(with: subscriptions[indexPath.row], at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
//        purchaseSubscription(at: indexPath.row)
//        reloadData()
        tableView.reloadData()
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
        IAPManager.shared.purchaseProduct(product: products[index], success: {
            print(" purchase succes")
            
            IAPManager.shared.subscriptionActiv = true
          FirebaseManager.shared.getPremiumData()
//          NotificationCenter.default.post(name: NSNotification.Name("ReloadSubscription"), object: nil)
//            self.reloadData()
            
        }) { (error) in
            print("error:\(error?.localizedDescription)")
//            let alertController = UIAlertController(title: "Error",
//                                                    message: error?.localizedDescription,
//                                                    preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .default))
//            self.present(alertController, animated: true, completion: nil)
        }
        
//        SubscriptionTypes.store.buyProduct(products[index]) { [weak self] success, productId in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                guard success else {
//                    
//                    let alertController = UIAlertController(title: "Failed to purchase product",
//                                                            message: "Check logs for details",
//                                                            preferredStyle: .alert)
//                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
//                    self.present(alertController, animated: true, completion: nil)
//                    
//                    return
//                }
//                //        self?.displayRandomQuote()
//            }
//        }
    }
    
    //delegate 
    func purchaseSubscription(_ subscriptionTableViewCell: SubscriptionTableViewCell, at index: Int) {
        purchaseSubscription(at: index)
    }

    @IBAction func restorePurchases(_ sender: Any) {
//      SubscriptionTypes.store.restorePurchases()
        IAPManager.shared.restorePurchases(success: {
            print("resttore")
            FirebaseManager.shared.getPremiumData()
            IAPManager.shared.subscriptionActiv = true 
        }) { (error) in
            print(error?.localizedDescription)
        }
    }
    
    @IBAction func cancelSubscription(_ sender: UIButton) {
        print("cancel")
        #if DEBUG
            UIApplication.shared.openURL(NSURL(string: "https://sandbox.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")! as URL)
        #else
            UIApplication.shared.openURL(NSURL(string: "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions")! as URL)
        #endif
        
    }
}
