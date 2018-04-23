//
//  ViewController.swift
//  AppsFlyerIAPSwift
//
//  Created by Jonathan Wesfield on 22/04/2018.
//  Copyright © 2018 AppsFlyer. All rights reserved.
//

import UIKit
import AppsFlyerLib
import StoreKit

class ViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var kConsumableItem = "com.appsflyer.inapppurchase.cons";
    var kConsumableItem1 = "com.appsflyer.exp.item";
    var kConsumableItem2 = "com.appsflyer.prod.three";
    var kConsumableItem3 = "com.appsflyer.product.one";
    var kConsumableItem4 = "com.appsflyer.inapppurchase.two";
    
    var productID = ""
    var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    var productToPurchase : SKProduct!
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAvailableProducts()
        print(canMakePurchases() ? "LOG CAN MAKE PURCHASE" : "DEBUG CAN NOT MAKE PURCHASE")
    }
    
    @IBAction func buyConsumablePressed(_ sender: Any) {
        if(iapProducts.count > 0){
            purchaseMyProduct(index: 0)
        } else {
            print("LOG : No Products")
        }
    }

   
     func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(){
        
        // Put here your IAP Products ID's
        let productIdentifiers = NSSet(objects: kConsumableItem4)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }

   
    func purchaseMyProduct(index: Int){
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            self.productToPurchase = product
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("LOG PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("LOG purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    if let product = productToPurchase {
                        
                        AppsFlyerTracker.shared().validateAndTrack(inAppPurchase:  product.productIdentifier, price: "\(product.price)", currency:  product.priceLocale.currencyCode, transactionId:  trans.transactionIdentifier, additionalParameters: nil,success:{(result) in
                         
                            if let response = result {
                                
                                print("LOG Purchase succeeded And verified!!! response \(String(describing: response))\n")
                                
                                if let product_id = response["product_id"]{
                                    print("\(product_id)")
                                }
                                if let transaction_id = response["transaction_id"]{
                                    print("\(transaction_id)")
                                }
                                if let quantity = response["quantity"]{
                                    print("\(quantity)")
                                }
                                if let purchase_date = response["purchase_date"]{
                                    print("\(purchase_date)")
                                }
                            }
                            
                        },failure:{(error,message) in
                            print("LOG response = \(String(describing: message))")
                        })
                        
                    }
                 
                    break
                    
                case .failed:
                    print("LOG failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                case .restored:
                    print("LOG restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    break
                    
                default: break
                }}}
    }

}

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}



