//
//  WishList.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 24/07/23.
//

import UIKit
class WishList:UIViewController,UITableViewDelegate,UITableViewDataSource
{
    
    let viewModel = WishListViewModel()
    var wishListResponse : WishListResponse?
    
    
    @IBOutlet weak var wishListTblView: UITableView!

    
    
    
    override func viewDidAppear(_ animated: Bool) {
        loadProducts()
    }
    
    private func loadProducts(){
        viewModel.loadWishlistData { response, error in
            guard  error == nil else {return}
            
            if  let response = response{
                self.wishListResponse = response
                
                
                
                DispatchQueue.main.async {
                    self.wishListTblView.reloadData()
                }
            }
            
        }
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = wishListResponse?.cartItems?.count ?? 0
        
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! WishListTableViewCell
        let item = wishListResponse?.cartItems?[indexPath.row]
        
        cell.wishListProductLabel.text = item?.product?.prdName
        cell.wishListPriceLabel.text = item?.product?.prdPrice
        if let imagePath = item?.product?.firstImage?.replacingOccurrences(of: "\\", with: "/") {
            UIImage.fetchImage(from: imagePath) { image in
                DispatchQueue.main.async {
                    cell.wishListImage.image = image
                }
            }
        }
        cell.wishListDeleteButton.tag = indexPath.row
        cell.wishListDeleteButton.addTarget(self, action: #selector(deleteRow), for: .touchUpInside)
        
        return cell
    }
    
    
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
                let item = wishListResponse?.cartItems?[sender.tag]
                if let id = item?.id {
                    self.deleteItem(for: String(id)) {
                        self.loadProducts()
                    }
                }
            }
        ))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func deleteItem(for id: String, completion: @escaping () -> Void) {
        viewModel.deleteRecord(Id: id) { [weak self] deleteResponse, error in
            guard let self = self else { return }
            guard error == nil, deleteResponse?.status == true else { return }

            DispatchQueue.main.async {
            
                completion()
            }
        }
    }
    
}
