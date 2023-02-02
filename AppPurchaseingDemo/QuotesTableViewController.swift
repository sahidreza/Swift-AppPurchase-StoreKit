//
//  QuotesTableViewController.swift
//  AppPurchaseingDemo
//
//  Created by Sahid Reza on 01/02/23.
//

import UIKit
import StoreKit

class QuotesTableViewController: UITableViewController {
    
    
    let productID = "com.appPurchse.Quotes"
    
    var quotesToShow:Array<String> = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes:Array<String> = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]
    
    
    @IBOutlet var quotesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self)
        if ispurchased(){
            showPeriumQuotes()
        }
        
    }
    
    @IBAction func submitBarButton(_ sender: UIBarButtonItem) {
        
        SKPaymentQueue.default().restoreCompletedTransactions()
        
    }
    
}

// MARK: - DatasourceDelegate && TableviewDelgate

extension QuotesTableViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if ispurchased(){
            
            return quotesToShow.count
        }else{
            
            return quotesToShow.count + 1
        }
       
       
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "insprongCell", for: indexPath)

        if indexPath.row < quotesToShow.count{
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.textColor = .black
            cell.accessoryType = .none
        }else{
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "More Quotes"
            cell.textLabel?.textColor = .blue
            cell.accessoryType = .disclosureIndicator
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row == quotesToShow.count{
            buyPreimumQuotes()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
   
    
}

// MARK: - Implement Apppurchase

extension QuotesTableViewController{
    
    func buyPreimumQuotes(){
        if SKPaymentQueue.canMakePayments(){
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
            
        }else{
            print("User Cant not make payements")
        }
    }
    
    
}

// MARK: - After Payment Using Delegate Menthod To Oberver payment Status

extension QuotesTableViewController:SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {

        for transtaction in transactions{
            if transtaction.transactionState == .purchased{
                //User payment successful
                
                showPeriumQuotes()
               
                SKPaymentQueue.default().finishTransaction(transtaction)
                
            }
            
            else if transtaction.transactionState == .failed{
                // User payment cancel
                if let error = transtaction.error{
                    let erroDescription = error.localizedDescription
                    print(erroDescription)
                }
                SKPaymentQueue.default().finishTransaction(transtaction)

            }else if transtaction.transactionState == .restored{
               
                showPeriumQuotes()
                navigationItem.setRightBarButton(nil, animated: true)
                SKPaymentQueue.default().finishTransaction(transtaction)
            }
        }


    }


}

// MARK: - Showing PriumQuotes

extension QuotesTableViewController{
    
    
    func showPeriumQuotes(){
        UserDefaults.standard.set(true, forKey: productID)
        quotesToShow.append(contentsOf: premiumQuotes)
        quotesTableView.reloadData()
        
    }
    
    func ispurchased() -> Bool {
        
        let purchasedStatus = UserDefaults.standard.bool(forKey: productID)
        
        if purchasedStatus {
            print("PerivioslyPerchased")
            return true
        }else{
            print("never Purchase")
            return false
        }
        
    }
    
}
