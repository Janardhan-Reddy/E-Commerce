//
//  CartViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class CartViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var totalSum = 0.0
    let viewModel = CartViewModel()
    var cartModelResponse: CartResponse?
    
    @IBOutlet weak var totlaAmt: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var CartTableView: UITableView!
    @IBAction func PlaceOrderAction(_ sender: UIButton) {
        
        handleCartCheckOut()
    }
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        self.setCustomTitle(withImage: "cart.circle", withTitle: "My Cart")
        self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .red, titleColor: .white)
        
        //initial Load
        let rupeeSymbol = "\u{20B9}"
        let balanceString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), totalSum)
        self.totlaAmt.text = balanceString
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        self.CartTableView.registerCells(cellIdentifiers: ["EmptyCartTableViewCell","CartCustomeCell" ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCartItems()
    }
    
    // MARK: Private Methods
    
    private func loadCartItems(){
        LoadingView.shared.show()
        let accessToken = UserDefaults.standard.string(forKey: "authToken")
        // if not logged in
        if accessToken == nil {
            LoadingView.shared.hide()
            navigateToLoginScreen()
        }
        viewModel.loadCartData { response, error in
            guard error == nil else {
                return
            }
            
            self.cartModelResponse = response
            DispatchQueue.main.async {
                
                LoadingView.shared.hide()
                self.showToast(message: response?.message ?? "Cart Retrived Successfully", iconName: "checkmark.circle.fill", backgroundColor: .systemGreen, duration: 1)
                let hideEmptyCart = response?.cartItems?.count == 0
                self.totlaAmt.isHidden = hideEmptyCart
                self.checkOutBtn.isHidden = hideEmptyCart
                
                self.recalculateTotal()
                self.CartTableView.reloadData()
            }
            
        }
    }
    
    private func navigateToLoginScreen(){
        showAlert(title: "Please Login",message: "Please Login to continue"){
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.set(false, forKey: "isLogin")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let sceneDelegate = windowScene.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                
                let nav = UINavigationController(rootViewController: loginVC)
                window.rootViewController = nav
                window.makeKeyAndVisible()
                
                // Optional: animation
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
    
    private func handleCartCheckOut(){
        guard let cartItems = cartModelResponse?.cartItems, !cartItems.isEmpty else {
            showAlert(title: "Cart Empty", message: "Please add some items to your cart.")
            return
        }
        var totalSum: Double = 0.0
        var billingModels: [BillingModel] = []
        
        for item in cartItems {
            guard let product = item.product,
                  let priceString = product.sellingPrice,
                  let price = Double(priceString),
                  let quantity = item.quantity else {
                continue
            }
            
            let itemTotal = price * Double(quantity)
            totalSum += itemTotal
            
            let billingItem = BillingModel(
                productImage: product.firstImage,
                productName: product.prdName,
                productPrice: product.sellingPrice,
                quantity: quantity,
                orderId: product.prdId ?? 0
            )
            
            billingModels.append(billingItem)
        }
        
        // No items with valid prices
        guard totalSum > 0 else {
            showAlert(title: "Invalid Cart", message: "Cart items contain invalid prices.")
            return
        }
        
        // Simulate delay before navigating
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let billingVC = storyboard.instantiateViewController(identifier: "BillingVC") as! BillingVC
            
            billingVC.billableItem = billingModels
            
            
            self.navigationController?.pushViewController(billingVC, animated: true)
        }
    }
    
    
    
    func deleteItem(for id: String, completion: @escaping () -> Void) {
        LoadingView.shared.show()
        viewModel.deleteRecord(Id: id) { [weak self] deleteResponse, error in
            guard let self = self else { return }
            guard error == nil, deleteResponse?.status == true else { return }
            
            DispatchQueue.main.async {
                self.recalculateTotal()
                LoadingView.shared.hide()
                completion()
            }
        }
    }
    
    func recalculateTotal() {
        let rupeeSymbol = "\u{20B9}"
        let total = cartModelResponse?.cartItems?.reduce(0.0) { partialResult, item in
            let price = Double(item.product?.prdPrice ?? "") ?? 0
            return partialResult + price
        } ?? 0.0
        
        let totalString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), total)
        self.totlaAmt.text = totalString
    }
    
    
    
    
}
extension CartViewController{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let safeitem = cartModelResponse?.cartItems, safeitem.count != 0 else {
            return tableView.bounds.height * 0.8
        }
        
        return 120
    }
    
    //delegate methods of tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cartModelResponse?.cartItems?.count != 0{
            return cartModelResponse?.cartItems?.count ?? 1
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let safeitem = cartModelResponse?.cartItems, safeitem.count != 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartTableViewCell") as! EmptyCartTableViewCell
            return cell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CartCustomeCell else {
            return UITableViewCell()
        }
        
        let item = safeitem[indexPath.row]
        let product = item.product
        cell.CartProductLabel.text = product?.prdName ?? "-"
        let price = product?.prdPrice ?? "-"
        cell.CartPriceLabel.text = "\u{20B9} \(price)"
        
        // Load image
        if let imagePath = product?.firstImage?.replacingOccurrences(of: "\\", with: "/") {
            UIImage.fetchImage(from: imagePath, baseURL: "https://gdrbpractice.gdrbtechnologies.com/") { image in
                DispatchQueue.main.async {
                    cell.CartImage.image = image
                }
            }
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
                let item = self.cartModelResponse?.cartItems?[indexPath.row]
                
                if let id = item?.card_id {
                    self.deleteItem(for: String(id)) {
                        self.loadCartItems()
                    }
                }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}
extension CartViewController{
    
    func showAlert(title: String, message: String, okHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            okHandler?()
        }))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
