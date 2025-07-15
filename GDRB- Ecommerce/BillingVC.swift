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

class BillingVC: UIViewController, RazorpayPaymentCompletionProtocol {

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
    var billableItem: BillingModel?
    var razorpay: RazorpayCheckout!
    let deliveryCharge: Double = 50
    var total: Double = 0

    // MARK: - Outlets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var changeAddressBtn: UIButton!
    @IBOutlet weak var deliveryOptionsTextField: UILabel!
    @IBOutlet weak var minusBtnPressed: UIButton!
    @IBOutlet weak var plusBtnPress: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var deliveryChargesLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBillingUI()
        razorpay = RazorpayCheckout.initWithKey("rzp_test_6d1SWcchqSjGGb", andDelegate: self)
    }

    // MARK: - Setup
    func setupBillingUI() {
        guard let item = billableItem else { return }
        let rupeeSymbol = "\u{20B9}"

        productNameLabel.text = item.productName ?? "No Name"
        productPriceLabel.text = rupeeSymbol + (item.productPrice ?? "0.00")
        quantityLabel.text = "\(item.quantity)"

        if let imageName = item.productImage {
            UIImage.fetchImage(from: imageName, baseURL: "https://gdrbpractice.gdrbtechnologies.com/") { image in
                DispatchQueue.main.async {
                    self.productImageView.image = image
                }
            }
        }

        updateTotals()
    }

    // MARK: - Actions
    @IBAction func onMinusAction(_ sender: UIButton) {
        guard var item = billableItem else { return }

        if item.quantity > 1 {
            item.quantity -= 1
            billableItem = item
            quantityLabel.text = "\(item.quantity)"
            updateTotals()
        }
    }

    @IBAction func onPlusAction(_ sender: UIButton) {
        guard var item = billableItem else { return }

        item.quantity += 1
        billableItem = item
        quantityLabel.text = "\(item.quantity)"
        updateTotals()
    }

    @IBAction func onContinuePress(_ sender: UIButton) {
        print("Continue pressed with item: \(String(describing: billableItem))")
        showPaymentForm()
    }

    // MARK: - Helpers
    func updateTotals() {
        let rupeeSymbol = "\u{20B9}"
        guard let item = billableItem,
              let priceStr = item.productPrice?.replacingOccurrences(of: rupeeSymbol, with: ""),
              let price = Double(priceStr)
        else {
            subtotalLabel.text = "\(rupeeSymbol) 0.00"
            totalLabel.text = "\(rupeeSymbol) 0.00"
            deliveryChargesLabel.text = "\(rupeeSymbol) \(deliveryCharge)"
            total = 0
            return
        }

        let subtotal = price * Double(item.quantity)
        total = subtotal + deliveryCharge

        subtotalLabel.text = String(format: "\(rupeeSymbol) %.2f", subtotal)
        deliveryChargesLabel.text = String(format: "\(rupeeSymbol) %.2f", deliveryCharge)
        totalLabel.text = String(format: "\(rupeeSymbol) %.2f", total)
    }

    internal func showPaymentForm() {
        let amountInPaise = Int(total * 100)

        let options: [String: Any] = [
            "amount": amountInPaise,
            "currency": "INR",
            "description": "Purchase from GDRB App",
            "image": "https://url-to-image.jpg",
            "name": billableItem?.productName ?? "Item",
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
}
