//
//  MyOrdersViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class MyOrdersViewController:UIViewController,UITableViewDelegate,UITableViewDataSource{
    //UIImage
    
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersCell",for: indexPath) as! MyordersCustomeCell
       
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
   
    }
      override func viewDidLoad() {
     
       
    }
}
