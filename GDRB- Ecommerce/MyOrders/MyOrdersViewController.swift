//
//  MyOrdersViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class MyOrdersViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    //UIImage
    
    @IBOutlet weak var OrdersTableView: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.OrdersTableView.registerCells(cellIdentifiers: ["EmptyCartTableViewCell"])
        self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .red, titleColor: .white)
        self.title = "My Orders"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyCartTableViewCell",for: indexPath) as! EmptyCartTableViewCell
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let emptyCellHeight = OrdersTableView.bounds.height * 0.85
        return emptyCellHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let ProductPage = storyboard.instantiateViewController(identifier: "ProductPage") as ProductPage
//        let navigationcontroller = UINavigationController(rootViewController: ProductPage)
//        ProductPage.modalPresentationStyle = .fullScreen
//        
//        self.navigationController?.pushViewController(ProductPage, animated: true)
//        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    
}
