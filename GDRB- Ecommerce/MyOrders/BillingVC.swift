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
    var orderId : Int
    
}


class BillingVC: UIViewController, RazorpayPaymentCompletionProtocol, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, AddressSelectionHandler {
   

    
    let deliveryOptions = [("Standard Delivery(Rs 50, 5-7 days)" , 50),
                   ("Express Delivery(Rs 100, 2-3 days)",100),
                   ("Same Day Delivery(Rs 200, Today)",200)]
    
    
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
    var placedOrder : [PlaceOrder] = []
    var razorpay: RazorpayCheckout!
    var deliveryCharge: Double = 50
    var total: Double = 0
    var myDropdown = DropdownSelectorView()
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
    
    
    @IBAction func changeAddressTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SavedAddress = storyboard.instantiateViewController(identifier: "SavedAddress") as SavedAddress
        SavedAddress.delegate = self 
        self.navigationController?.pushViewController(SavedAddress, animated: true)
        
    }
  
       
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .red, titleColor: .white)
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
       

        self.setCustomTitle(withImage: "bag.circle", withTitle: "My Orders")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemTableViewHeight.constant = CGFloat(placedOrder.count * 130)
        totalHeight.constant = CGFloat(placedOrder.count * 130) + totalHeight.constant
     
        saveBillableItemsToCoreDataIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.fetchPlaceOrderItemsAndDisplay()
            
        }
    }
    
    func saveBillableItemsToCoreDataIfNeeded() {
     
        let existingItems = DatabaseHandler.shared.fetchEntities(ofType: PlaceOrder.self)

        for billing in billableItem {
            let orderId = Int64(billing.orderId)
            let productName = billing.productName

            let isAlreadySaved = existingItems.contains { item in
                item.orderId == orderId && item.productName == productName
            }

            // If not found, save it
            if !isAlreadySaved {
                if let placedItem = DatabaseHandler.shared.createEntity(ofType: PlaceOrder.self) {
                    placedItem.productImage = billing.productImage
                    placedItem.productName = productName
                    if let priceString = billing.productPrice?
                                            .replacingOccurrences(of: "₹", with: "")
                                            .trimmingCharacters(in: .whitespacesAndNewlines),
                       let priceDouble = Double(priceString) {
                        placedItem.productPrice = Int64(priceDouble)
                    } else {
                        placedItem.productPrice = 0
                    }

                    placedItem.productQuantity = Int64(billing.quantity)
                    placedItem.orderId = orderId
                }
            }
        }

        DatabaseHandler.saveContext()
    }

    
    func fetchPlaceOrderItemsAndDisplay() {
        let items = DatabaseHandler.shared.fetchEntities(ofType: PlaceOrder.self)
        self.placedOrder = items
        self.updateTotals()
        self.itemTableViewHeight.constant = CGFloat(self.placedOrder.count * 130)
        self.totalHeight.constant = self.itemTableViewHeight.constant + self.baseTotalHeight
        productListTableView.reloadData()
    }
    

    
    // MARK: - Setup
    
    @IBAction func onContinuePress(_ sender: UIButton) {
        print("Continue pressed with item: \(placedOrder)")
        if placedOrder.isEmpty{
            showAlert(title: "Items Empty", message: "Please add atleast one item")
            return
        }
        showPaymentForm()
    }
    
    // MARK: - Helpers
    func updateTotals() {
        let rupeeSymbol = "\u{20B9}"
        var subtotal: Double = 0.0
        
        placedOrder.forEach { item in
            let priceStr = item.productPrice
            let price = Double(priceStr)
            subtotal += price * Double(item.productQuantity)
        }
        
        total = subtotal + deliveryCharge
        
        subtotalLabel.text = String(format: "\(rupeeSymbol) %.2f", subtotal)
        deliveryChargesLabel.text = String(format: "\(rupeeSymbol) %.2f", deliveryCharge)
        totalLabel.text = String(format: "\(rupeeSymbol) %.2f", total)
    }
    
    func showPaymentForm() {
        let amountInPaise = Int(total * 100)
        
        // Combine all product names for Razorpay "name" field
        let combinedName = placedOrder.map { $0.productName ?? "Item" }.joined(separator: ", ")
        
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
    

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == deliveryOptionsTextField {
           
            presentDropdown(anchor: deliveryOptionsTextField)

        }
        return false
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placedOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell") as! ProductListCell
        
        cell.productNameLabel.text = placedOrder[indexPath.row].productName ?? ""
        cell.quantityLabel.text =
        String(placedOrder[indexPath.row].productQuantity)
        
        let price = Double(placedOrder[indexPath.row].productPrice)
        cell.productPriceLabel.text = String(format: "\u{20B9} %.2f", price)
        
        UIImage.fetchImage(from: placedOrder[indexPath.row].productImage ?? "", baseURL: "https://gdrbpractice.gdrbtechnologies.com/") { image in
            DispatchQueue.main.async {
                cell.productImageView.image = image
            }
        }
        
        
        
        cell.onQuantityChanged = { [weak self] isIncrement in
            guard let self = self else { return }
            var quantity = self.placedOrder[indexPath.row].productQuantity
            if isIncrement {
                quantity += 1
            } else {
                quantity = max(1, quantity - 1)
            }
            self.placedOrder[indexPath.row].productQuantity = Int64(quantity)
            self.productListTableView.reloadRows(at: [indexPath], with: .automatic)
            self.updateTotals()
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            
            // Show confirmation alert (optional)
            let alert = UIAlertController(
                title: "Delete",
                message: "Are you sure you want to delete this item?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
              
                DatabaseHandler.shared.deleteEntity(self.placedOrder[indexPath.row])
                self.placedOrder.remove(at: indexPath.row)
                self.productListTableView.reloadData()
                self.updateTotals()
                self.itemTableViewHeight.constant = CGFloat(self.placedOrder.count * 130)
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
    
    func onAddressCellSelected(_ address: Address) {
        let name = address.fullName?.capitalized ?? ""
        
        let addressString = [
            address.flatNumber,
            address.localAddress?.capitalized,
            address.landmark?.capitalized,
            address.city?.capitalized,
            address.state?.capitalized,
            "India - \(address.pincode)"
        ]
        .compactMap { $0 }
        .joined(separator: ", ")
        
        let phoneNumber = String(address.phoneNumber)
        deliveryAddress.text = "\(name)\n\(addressString)\nPhone: \(phoneNumber)"
    }

    
}

extension BillingVC: DropdownDataSource{//dropdown selection
    func numberOfDropdownItems() -> Int {
        deliveryOptions.count
    }
    
    func dropdownItemTitle(at index: Int) -> String {
        deliveryOptions[index].0
    }
    
    func didSelectDropdownItem(at index: Int) {
        let selectedText = deliveryOptions[index].0
        self.deliveryOptionsTextField.text = selectedText
        let selectedAmount = deliveryOptions[index].1
        self.deliveryCharge = Double(selectedAmount)
            self.updateTotals()
        
      
    }
    
    func presentDropdown(anchor: UITextField) {
           myDropdown.show(over: view, anchor: anchor, dataSource: self)
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

