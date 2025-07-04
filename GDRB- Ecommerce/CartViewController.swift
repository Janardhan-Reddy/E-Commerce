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
    var retriveCart = CartDataBaseScreen()
    var cartDetails:[CartDetails] = []
    var cartDelete:[CartDetails] = []
   
    @IBOutlet weak var totlaAmt: UILabel!
    // UIImage of Cart
    var CartImage : [UIImage] = [UIImage(named: "recent")!,
                                    UIImage(named: "recent2")!,
                                    UIImage(named: "recent5")!,
                                    UIImage(named: "recent4")!,]
                                    
   // UILabels of Cart
    var CartProductLabel:[String] = ["iphone14","iphone14pro","ipad","Airpods"]
    let CartPriceLabel:[String]  = ["86,899","96,989","95,479","12,569"]
    let CartCategoryLabel:[String]  = ["Mobile","Mobile","Mobile","Electronics"]
 
    
    //delegate methods of tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cartDetails.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! CartCustomeCell
        cell.CartPriceLabel.text =  "\u{20B9} \(cartDetails[indexPath.row].productprice)"
        cell.CartProductLabel.text = cartDetails[indexPath.row].productname
        cell.CartCategoryLabel.text = cartDetails[indexPath.row].productcategory
        cell.CartImage.image = cartDetails[indexPath.row].image
       // cell.CartLoveButton.setImage(UIImage(named: "fav"), for: .normal)
        cell.CartDeleteButton.tag = indexPath.row
        cell.CartDeleteButton.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
        
        return cell
    }
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: CartTableView)
        guard let indexPath = CartTableView.indexPathForRow(at: point) else { return }

        let alert = UIAlertController(
            title: "Delete",
            message: "Are you sure you want to delete",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { [weak self] _ in
                guard let self = self else { return }
                
                let item = self.cartDetails[indexPath.row]
                let name = item.productname
                
                self.retriveCart.deleteByName(productname: name)
                
                // Remove item from data source and reload table view
                self.cartDetails.remove(at: indexPath.row)
                self.CartTableView.deleteRows(at: [indexPath], with: .fade)
                let total = totalSum - Double(item.productprice)!
                let rupeeSymbol = "\u{20B9}"
                let balanceString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), total)
                self.totlaAmt.text = balanceString
                self.CartTableView.reloadData()
                
            }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }


    
    @IBAction func CartDelete(_ sender: Any) {
              
           }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //push navigationController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ProductPage = storyboard.instantiateViewController(identifier: "ProductPage") as ProductPage
        let data = cartDetails[indexPath.row]
        ProductPage.image = data.image
        ProductPage.price = data.productprice
        ProductPage.Description = data.productDiscription
        ProductPage.rating = data.productRating
        ProductPage.productName = data.productname
        ProductPage.productCategory = data.productcategory
        self.navigationController?.pushViewController(ProductPage, animated: true)
        ProductPage.modalPresentationStyle = .fullScreen
        tableView.deselectRow(at: indexPath, animated: true)
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
    override func viewDidAppear(_ animated: Bool) {
       cartDetails = retriveCart.retrieveProductsDetails()
        CartTableView.reloadData()
       
       
      
        
       
    }
    override func viewDidLoad() {
         self.title = "My Cart"
        cartDetails = retriveCart.retrieveProductsDetails()

        for amount in cartDetails {
            if let productPrice = Double(amount.productprice) {
                totalSum += productPrice
            } else {
                // Handle the case where the product price is not convertible to a Double
                print("Invalid product price: \(amount.productprice)")
            }
        }

        let rupeeSymbol = "\u{20B9}"
        let balanceString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), totalSum)
        self.totlaAmt.text = balanceString
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        CartTableView.register(UINib(nibName: "CartCustomeCell", bundle: nil), forCellReuseIdentifier: "CartCustomeCell")
       // self.tabBarController?.navigationItem.hidesBackButton = false
      
    }
}
