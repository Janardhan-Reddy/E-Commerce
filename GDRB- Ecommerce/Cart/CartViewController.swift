//
//  CartViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class CartViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var indexForCell = Int()
    var totalSum = 0.0
    let viewModel = CartViewModel()
    var cartModelResponse: CartResponse?
    
    @IBOutlet weak var totlaAmt: UILabel!
    // UIImage of Cart
    
    @IBOutlet weak var checkOutBtn: UIButton!
    
    override func viewDidLoad() {
        self.title = "My Cart"
        
        self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .red, titleColor: .white)
        let rupeeSymbol = "\u{20B9}"
        let balanceString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), totalSum)
        self.totlaAmt.text = balanceString
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
       
        self.CartTableView.registerCells(cellIdentifiers: ["EmptyCartTableViewCell","CartCustomeCell" ])

    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCartItems()
    }
    
    
    
    private func loadCartItems(){
        LoadingView.shared.show()
        let accessToken = UserDefaults.standard.string(forKey: "authToken")
        if accessToken == nil {
            LoadingView.shared.hide()
            showAlert(title: "Please Login",message: "Please Login to continue"){
                UserDefaults.standard.removeObject(forKey: "authToken")
                   UserDefaults.standard.set(false, forKey: "isLogin")

                   // Load Login screen from storyboard
                   let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")

                   // Set login screen as the rootViewController, removing TabBarController
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

        // Set product name and price
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

        // Assign delete action


        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let item = cartModelResponse?.cartItems?[indexPath.row]
            
            // Show confirmation alert (optional)
            let alert = UIAlertController(
                title: "Delete",
                message: "Are you sure you want to delete this item?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
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

   
    
    
    
    @IBAction func CartDelete(_ sender: Any) {
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        guard let safeitem = cartModelResponse?.cartItems, safeitem.count != 0 else {
            return tableView.bounds.height * 0.8
        }
        
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //push navigationController
        //        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let ProductPage = storyboard.instantiateViewController(identifier: "ProductPage") as ProductPage
        //        let data = cartDetails[indexPath.row]
        //        ProductPage.image = data.image
        //        ProductPage.price = data.productprice
        //        ProductPage.Description = data.productDiscription
        //        ProductPage.rating = data.productRating
        //        ProductPage.productName = data.productname
        //        ProductPage.productCategory = data.productcategory
        //        self.navigationController?.pushViewController(ProductPage, animated: true)
        //        ProductPage.modalPresentationStyle = .fullScreen
        //        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBOutlet weak var CartTableView: UITableView!
    //PlaceOrderButtonAction
    @IBAction func PlaceOrderAction(_ sender: UIButton) {
       
        guard let cartItems = cartModelResponse?.cartItems, !cartItems.isEmpty else {
            showAlert(title: "Cart Empty", message: "Please add some items to your cart.")
            return
        }

        // Compute total price (assuming price is a string like "12.99")
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
                quantity: quantity
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
