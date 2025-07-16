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
        
        viewModel.loadWishlistData { response, error in
            guard  error == nil else {return}
            
            if  let response = response{
                self.wishListResponse = response
                DispatchQueue.main.async {
                    LoadingView.shared.hide()
                    self.showToast(message: response.message ?? "Wishlist Retrived Successfully", iconName: "checkmark.circle.fill", backgroundColor: .systemGreen, duration: 1)
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
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            guard let self = self else { return }
            
            let item = wishListResponse?.wishListItems?[indexPath.row]
            
            // Show confirmation alert (optional)
            let alert = UIAlertController(
                title: "Delete",
                message: "Are you sure you want to delete this item?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
                if let id = item?.id {
                    self.deleteItem(for: String(id)) {
                        self.loadProducts()
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
