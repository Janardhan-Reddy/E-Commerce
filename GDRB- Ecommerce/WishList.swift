//
//  WishList.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 24/07/23.
//

import UIKit
class WishList:UIViewController,UITableViewDelegate,UITableViewDataSource
{
    var retriveWishList = WishListDataBase()
    var productDetails:[WishListDetails] = []
    @IBOutlet weak var wishListTblView: UITableView!
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: wishListTblView)
        guard let indexPath = wishListTblView.indexPathForRow(at: point) else { return }

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
                
                let item = self.productDetails[indexPath.row]
                let name = item.productname
                
                self.retriveWishList.deleteByName(productname: name)
                
                // Remove item from data source and reload table view
                self.productDetails.remove(at: indexPath.row)
                self.wishListTblView.deleteRows(at: [indexPath], with: .fade)
            }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }


    
    override func viewDidLoad() {
        
    }
    override func viewDidAppear(_ animated: Bool) {
        productDetails = retriveWishList.retrieveProductsDetails()
        wishListTblView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! WishListTableViewCell
        cell.wishListImage.image = productDetails[indexPath.row].image
        cell.wishListProductLabel.text = productDetails[indexPath.row].productname
        cell.wishListPriceLabel.text = productDetails[indexPath.row].productprice
        cell.wishListCategoryLabel.text = productDetails[indexPath.row].productcategory
        
        cell.wishListDeleteButton.tag = indexPath.row
        cell.wishListDeleteButton.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
        return cell
    }
    
    
}
