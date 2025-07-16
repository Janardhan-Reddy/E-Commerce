//
//  BillingVC.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 14/07/25.
//
import UIKit
import Razorpay

struct BillingModel {
    var productImage: String?
    var productName: String?
    var productPrice: String?
    var quantity: Int = 1
}


class BillingVC: UIViewController, RazorpayPaymentCompletionProtocol, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    // MARK: - Razorpay Delegate
    func onPaymentError(_ code: Int32, description str: String) {
        print("Payment failed: \(code) - \(str)")
        showAlert(title: "Payment Failed", message: str)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        print("Payment success: \(payment_id)")
        showAlert(title: "Payment Successful", message: "Payment ID: \(payment_id)")
    }
    
    // MARK: - Properties
    var billableItem: [BillingModel] = []
    var razorpay: RazorpayCheckout!
    var deliveryCharge: Double = 50
    var total: Double = 0
    var dropdownSelector: DropdownSelectorView?
    var baseTotalHeight: CGFloat = 0
    
    // MARK: - Outlets
    
    @IBOutlet weak var totalHeight: NSLayoutConstraint!
    @IBOutlet weak var productListTableView: UITableView!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var changeAddressBtn: UIButton!
    @IBOutlet weak var deliveryOptionsTextField: UITextField!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var itemTableViewHeight: NSLayoutConstraint!
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deliveryOptionsTextField.delegate = self
        productListTableView.delegate = self
        productListTableView.dataSource = self
        razorpay = RazorpayCheckout.initWithKey("rzp_test_6d1SWcchqSjGGb", andDelegate: self)
        updateTotals()
        baseTotalHeight = totalHeight.constant
        deliveryOptionsTextField.addRightImageTo(
            padding: 13,
            height: 13,
            width: 20,
            image: UIImage(systemName: "chevron.down") ?? UIImage(),
            tintColour: .darkGray
        ) {
            self.deliveryOptionsTextField.becomeFirstResponder()
        }
        
        itemTableViewHeight.constant = CGFloat(billableItem.count * 130)
        totalHeight.constant = CGFloat(billableItem.count * 130) + totalHeight.constant
    }
    
    // MARK: - Setup
    
    @IBAction func onContinuePress(_ sender: UIButton) {
        print("Continue pressed with item: \(billableItem)")
        if billableItem.isEmpty{
            showAlert(title: "Items Empty", message: "Please add atleast one item")
            return
        }
        showPaymentForm()
    }
    
    // MARK: - Helpers
    func updateTotals() {
        let rupeeSymbol = "\u{20B9}"
        var subtotal: Double = 0.0
        
        billableItem.forEach { item in
            guard let priceStr = item.productPrice,
                  let price = Double(priceStr) else { return }
            subtotal += price * Double(item.quantity)
        }
        
        total = subtotal + deliveryCharge
        
        subtotalLabel.text = String(format: "\(rupeeSymbol) %.2f", subtotal)
        deliveryChargesLabel.text = String(format: "\(rupeeSymbol) %.2f", deliveryCharge)
        totalLabel.text = String(format: "\(rupeeSymbol) %.2f", total)
    }
    
    func showPaymentForm() {
        let amountInPaise = Int(total * 100)
        
        // Combine all product names for Razorpay "name" field
        let combinedName = billableItem.map { $0.productName ?? "Item" }.joined(separator: ", ")
        
        let options: [String: Any] = [
            "amount": amountInPaise,
            "currency": "INR",
            "description": "Purchase from GDRB App",
            "image": "https://url-to-image.jpg",
            "name": combinedName,
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        
        razorpay.open(options)
    }
    
    private func showAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == deliveryOptionsTextField {
            let options = ["Standard Delivery(Rs 50, 5-7 days)",
                           "Express Delivery(Rs 100, 2-3 days)",
                           "Same Day Delivery(Rs 200, Today)"]
            
            dropdownSelector = DropdownSelectorView()
            dropdownSelector?.show(over: self.view, anchor: textField, items: options, onSelect: { [weak self] selected in
                self?.deliveryOptionsTextField.text = selected
                if let match = selected.range(of: #"Rs\s*(\d+)"#, options: .regularExpression) {
                    let amountString = String(selected[match]).replacingOccurrences(of: "Rs", with: "").trimmingCharacters(in: .whitespaces)
                    if let amount = Double(amountString) {
                        self?.deliveryCharge = amount
                        self?.updateTotals()
                    }
                }
                self?.dropdownSelector = nil
            })
        }
        return false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billableItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell") as! ProductListCell
        
        cell.productNameLabel.text = billableItem[indexPath.row].productName ?? ""
        cell.quantityLabel.text =
        "\(billableItem[indexPath.row].quantity )"
        cell.productPriceLabel.text = billableItem[indexPath.row].productPrice ?? ""
        
        UIImage.fetchImage(from: billableItem[indexPath.row].productImage ?? "", baseURL: "https://gdrbpractice.gdrbtechnologies.com/") { image in
            DispatchQueue.main.async {
                cell.productImageView.image = image
            }
        }
        
        
        
        cell.onQuantityChanged = { [weak self] isIncrement in
            guard let self = self else { return }
            var quantity = self.billableItem[indexPath.row].quantity
            if isIncrement {
                quantity += 1
            } else {
                quantity = max(1, quantity - 1)
            }
            self.billableItem[indexPath.row].quantity = quantity
            self.productListTableView.reloadRows(at: [indexPath], with: .automatic)
            self.updateTotals()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let item = billableItem[indexPath.row]
            
            // Show confirmation alert (optional)
            let alert = UIAlertController(
                title: "Delete",
                message: "Are you sure you want to delete this item?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                self.billableItem.remove(at: indexPath.row)
                self.productListTableView.reloadData()
                self.updateTotals()
                self.itemTableViewHeight.constant = CGFloat(self.billableItem.count * 130)
                self.totalHeight.constant = self.itemTableViewHeight.constant + self.baseTotalHeight
                completionHandler(true)
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(false)
            })
            
            self.present(alert, animated: true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = false // Optional: prevent full-swipe delete
        
        return configuration
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

class ProductListCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var onQuantityChanged: ((Bool) -> Void)? // true = plus, false = minus
    
    
    
    @IBAction func onMinusAction(_ sender: UIButton) {
        onQuantityChanged?(false)
    }
    
    @IBAction func onPlusAction(_ sender: UIButton) {
        onQuantityChanged?(true)
    }
}

