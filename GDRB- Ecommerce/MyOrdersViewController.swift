//
//  MyOrdersViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class MyOrdersViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    //UIImage
    var MyorderImage : [UIImage] = [UIImage(named: "recent3")!,
                                    UIImage(named: "recent4")!,
                                    UIImage(named: "recent5")!,
                                    UIImage(named: "recent")!,]
    
    
    var retriveOrders = MyOrdersDataBase()
    var Details:[MyOrdersDetails] = []
    var Delete:[MyOrdersDetails] = []
   
    //UILabel
    let MyorderProductLabel:[String] = ["iphone14pro","ipad","Apple airpods","iphone13"]
    let MyorderPriceLabel:[String]  = ["98,789","99,989","15,545","78,898"]
    let MyorderCategoryLabel:[String]  = ["Mobiles","Mobiles","Electronics","Mobile"]
   //tableview delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Details.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell",for: indexPath) as! MyordersCustomeCell
        cell.MyorderProductLabel.text = Details[indexPath.row].productname
        cell.MyorderCategoryLabel.text = Details[indexPath.row].productcategory
        cell.MyorderPriceLabel.text = "\u{20B9} \(Details[indexPath.row].productprice)"
        cell.MyorderImage.image = Details[indexPath.row].image
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ProductPage = storyboard.instantiateViewController(identifier: "ProductPage") as ProductPage
        let navigationcontroller = UINavigationController(rootViewController: ProductPage)
      ProductPage.modalPresentationStyle = .fullScreen

        self.navigationController?.pushViewController(ProductPage, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)

            }
    
    
    @IBOutlet weak var OrdersTableView: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        Details = retriveOrders.retrieveProductsDetails()
     let i = Details
        print(i.count)
        OrdersTableView.reloadData()
    }
      override func viewDidLoad() {
     
       
    }
}
