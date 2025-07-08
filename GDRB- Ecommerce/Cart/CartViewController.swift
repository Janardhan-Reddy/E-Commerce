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
    
    
    override func viewDidLoad() {
        self.title = "My Cart"
        
        self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .red, titleColor: .white)
        let rupeeSymbol = "\u{20B9}"
        let balanceString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), totalSum)
        self.totlaAmt.text = balanceString
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        CartTableView.register(UINib(nibName: "CartCustomeCell", bundle: nil), forCellReuseIdentifier: "CartCustomeCell")
        // self.tabBarController?.navigationItem.hidesBackButton = false
        
       
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCartItems()
    }
    
    
    
    private func loadCartItems(){
        LoadingView.shared.show()
        viewModel.loadCartData { response, error in
            guard error == nil else {
                return
            }
            
            self.cartModelResponse = response
            DispatchQueue.main.async {
                LoadingView.shared.hide()
                self.recalculateTotal()
                self.CartTableView.reloadData()
            }
            
        }
    }
    
    
    //delegate methods of tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cartModelResponse?.cartItems?.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? CartCustomeCell else {
            return UITableViewCell()
        }

        let item = cartModelResponse?.cartItems?[indexPath.row]
        let product = item?.product

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
        cell.deleteAction = { [weak self] _ in
            guard let self = self else { return }
            
            let alert = UIAlertController(
                title: "Delete",
                message: "Are you sure you want to delete?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                if let id = item?.card_id {
                    self.deleteItem(for: String(id)) {
                        self.loadCartItems()
                    }
                }
            })
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
        }

        return cell
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
        return 100
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            //push navigationController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let OrderSummaryController = storyboard.instantiateViewController(identifier: "OrderSummaryController") as OrderSummaryController
            
            OrderSummaryController.total =  self.totalSum
            
            self.navigationController?.pushViewController(OrderSummaryController, animated: true)
        }
    }
    
}
