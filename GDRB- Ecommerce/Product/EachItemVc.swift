//
//  EachItemVc.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 08/07/25.
//

import UIKit
class EachItemVc: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    var eachItemData: Product?
    var similarProductData: ProductsData?
    var viewModel = EachItemViewModel()
    @IBOutlet weak var imagePreviewCollectionview: UICollectionView!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var offersandCoupons: UILabel!
    @IBOutlet weak var descriptionHeader: UILabel!
    @IBOutlet weak var descriptionTxt: UILabel!
    @IBOutlet weak var similarProductsCollectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreviewCollectionview.delegate = self
        imagePreviewCollectionview.dataSource = self
        similarProductsCollectionView.delegate = self
        similarProductsCollectionView.dataSource = self
        imagePreviewCollectionview.isPagingEnabled = true
        ProductName.text = eachItemData?.prdName ?? "-"
        let rupeeSymbol = "\u{20B9}"
        let price = eachItemData?.prdPrice ?? "-"
        productPrice.text = "Price: \(rupeeSymbol)\(price)"
        
        descriptionTxt.text = eachItemData?.prdDescription ?? "-"
        similarProductsCollectionView.isPagingEnabled = true
        setupLayoutForSimilarProductView()
        setupRecommededFlowLayout()
        setupLayoutForSimilarProductView()
        
    }
    
    
    func setupRecommededFlowLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = imagePreviewCollectionview.bounds.size
        imagePreviewCollectionview.collectionViewLayout = layout
        
    }
    
    @IBAction func addToCartPressed(_ sender: UIButton) {
        guard let productId = eachItemData?.prdId else { return }
        LoadingView.shared.show()
           viewModel.addProductToCart(prd_id: String(productId), quantity: "1") { response, error in
               guard error == nil else { return }
               DispatchQueue.main.async {
                   LoadingView.shared.hide()
                   if let response = response, response.status == true {
                      
                       self.showToast(message: response.message ?? "Added to cart successfully", iconName: "cart.badge.plus", backgroundColor: .systemGreen)

                   } else if let response = response, response.status == false{
                       
                       self.showToast(message: response.message ?? "Product already in cart", iconName: "exclamationmark.triangle.fill", backgroundColor: .systemOrange)

                   }else{
                       self.showAlert(header: "Failed!", message:  "Adding Item Failed")
                   }
               }
           }
       }

       @IBAction func buyNowPressed(_ sender: UIButton) {
           // Implement your Buy Now logic here
       }

       @IBAction func onWishListPressed(_ sender: UIButton) {
           guard let productId = eachItemData?.prdId else { return }

           if sender.isSelected {
               sender.isSelected = false
               sender.setImage(UIImage(systemName: "heart"), for: .normal)
           } else {
               LoadingView.shared.show()
               viewModel.addProductToWishList(prd_id: String(productId), quantity: "1") { response, error in
                   guard error == nil else { return }
                   LoadingView.shared.hide()
                   DispatchQueue.main.async {
                       if let response = response, response.status == true {
                          
                           self.showToast(message: response.message ?? "Added to Wishlist successfully", iconName: "cart.badge.plus", backgroundColor: .systemGreen)
                           
                           sender.isSelected = true
                           sender.setImage(UIImage(systemName: "heart.fill"), for: .selected)
                       } else {
                           self.showAlert(header: "Failed!", message: "Failed to add to wishlist.")
                           sender.setImage(UIImage(systemName: "heart"), for: .normal)
                       }
                   }
               }
           }
       }
    
    
    func setupLayoutForSimilarProductView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let height = similarProductsCollectionView.bounds.height
        let width = similarProductsCollectionView.bounds.width

        let cellWidth = width / 1.7
        layout.itemSize = CGSize(width: cellWidth, height: height)

        similarProductsCollectionView.collectionViewLayout = layout
        similarProductsCollectionView.showsHorizontalScrollIndicator = false
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagePreviewCollectionview {
            return eachItemData?.images?.count ?? 0
              } else {
                  return similarProductData?.products?.count ?? 0
              }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == imagePreviewCollectionview {
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imagePreviewClnCell", for: indexPath) as! imagePreviewClnCell

            if let imagePath = eachItemData?.images?[indexPath.row].replacingOccurrences(of: "\\", with: "/") {
                       UIImage.fetchImage(from: imagePath, baseURL: "https://gdrbpractice.gdrbtechnologies.com/") { image in
                           DispatchQueue.main.async {
                               cell.imageView.image = image
                           }
                       }
                   }
                   return cell
               } else {
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarProductsClnViewCell", for: indexPath) as! SimilarProductsClnViewCell

                   let product = similarProductData?.products?[indexPath.row]
                   if let imagePath = product?.firstImage?.replacingOccurrences(of: "\\", with: "/") {
                       UIImage.fetchImage(from: imagePath, baseURL: "https://gdrbpractice.gdrbtechnologies.com/") { image in
                           DispatchQueue.main.async {
                               cell.imageView.image = image
                           }
                       }
                   }
                   cell.itemName.text = product?.prdName ?? "-"
                   
                   let rupeeSymbol = "\u{20B9}"
                   let price = product?.prdPrice ?? "-"
                   cell.itemPrice.text = "Price: \(rupeeSymbol)\(price)"
                   
                   return cell
               }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarProductsCollectionView{
            self.eachItemData =  similarProductData?.products?[indexPath.row]
            DispatchQueue.main.async {
                self.ProductName.text = self.eachItemData?.prdName ?? "-"
                let rupeeSymbol = "\u{20B9}"
                let price = self.eachItemData?.prdPrice ?? "-"
                self.productPrice.text = "Price: \(rupeeSymbol)\(price)"
                self.descriptionTxt.text = self.eachItemData?.prdDescription ?? "-"
                self.imagePreviewCollectionview.reloadData()
            }
            
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func showAlert(header: String, message: String) {
      let alert = UIAlertController(
        title: title,
        message: message,
        preferredStyle: .alert
      )
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async{
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}



class imagePreviewClnCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    
    
}


class SimilarProductsClnViewCell: UICollectionViewCell{
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var itemName: UILabel!
    
    @IBOutlet weak var itemPrice: UILabel!
}
