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

    @IBOutlet weak var totalAmount: UILabel!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.title = "Wish List"
        loadProducts()
    }
    
    private func loadProducts(){
        LoadingView.shared.show()
        viewModel.loadWishlistData { response, error in
            guard  error == nil else {return}
            
            if  let response = response{
                self.wishListResponse = response
                DispatchQueue.main.async {
                    LoadingView.shared.hide()
                    self.recalculateTotal()
                    self.wishListTblView.reloadData()
                }
            }
            
        }
    }
    
    func recalculateTotal() {
        let rupeeSymbol = "\u{20B9}"
        let total = wishListResponse?.wishListItems?.reduce(0.0) { partialResult, item in
            let price = Double(item.product?.prdPrice ?? "") ?? 0
            return partialResult + price
        } ?? 0.0

        let totalString = String(format: NSLocalizedString("Total Amount: \(rupeeSymbol) %.2f", comment: ""), total)
        self.totalAmount.text = totalString
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let itemCount = wishListResponse?.wishListItems?.count ?? 0
        
        return itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath) as! WishListTableViewCell
        let item = wishListResponse?.wishListItems?[indexPath.row]
        
        cell.wishListProductLabel.text = item?.product?.prdName
        let rupeeSymbol = "\u{20B9}"
        let price = item?.product?.prdPrice ?? "-"
        cell.wishListPriceLabel.text = "Price: \(rupeeSymbol)\(price)"
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    @objc func deleteRow(_ sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: wishListTblView)
      
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
                let item = wishListResponse?.wishListItems?[sender.tag]
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
        LoadingView.shared.show()
        viewModel.deleteRecord(Id: id) { [weak self] deleteResponse, error in
            guard let self = self else { return }
            guard error == nil, deleteResponse?.status == true else { return }

            DispatchQueue.main.async {
                LoadingView.shared.hide()
                completion()
            }
        }
    }
    
}
