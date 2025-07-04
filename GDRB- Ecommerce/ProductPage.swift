//
//  ProductPage.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 23/11/22.
//

import UIKit
class ProductPage:UIViewController{
    var image:UIImage?
    var productName:String?
    var price:String?
    var productCategory:String?
    var Description:String?
    var rating:String?
    var retriveData:CartDataBaseScreen = CartDataBaseScreen()
    var products:[CartDetails] = []
    var insertData = WishListDataBase()

    @IBOutlet weak var ScrollProductPage: UIScrollView!
    
    @IBOutlet weak var pName: UILabel!
    
    @IBOutlet weak var productRating: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    let cartInsertDetails = CartDataBaseScreen()
    let RecentPageController = UIPageControl()
    
    let ProductImage:[String] = ["mobile","mobile2","mobile9","mobile8","mobile3"]
   let ProductName:[String] = ["Fashion","fashion","fashion","fashion","fashion"]
    let productPrice:[String]  = ["15000","1200","1200","1200","1500","16200"]
    let RecentImage:[String] = ["recent","recent3","recent","recent3","recent3"]
   let RecentLabel:[String] = ["iphone14","iphone14pro","iphone13","iphone14proMax","iphone14"]
    @IBOutlet weak var RecentProductCollectionView: UICollectionView!
    @IBOutlet weak var ProductCollectionView: UICollectionView!
   
  
    @IBAction func Favourite(_ sender: Any) {
        insertData.insert(productname: productName ?? "nil", productprice: price ?? "nil", productcategory: productCategory ?? "nil", productDiscription: Description ?? "nil", productRating: rating ?? "nil", image: image!)
     }
    @objc func favoriteButtonTapped() {
        FavouriteButton.isSelected.toggle()
        
        if FavouriteButton.isSelected {
            // Handle favorite button selected
            print("Item favorited!")
        } else {
            // Handle favorite button deselected
            print("Item unfavorited.")
        }
    }
    //cartButtonAction
    @IBAction func cartAction(_ sender: Any) {
        cartInsertDetails.insert(productname: productName ?? "nil", productprice: price ?? "nil", productcategory: productCategory ?? "nil", productDiscription: Description ?? "nil", productRating: rating ?? "nil", image: image!)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let CartViewController = storyboard.instantiateViewController(identifier: "CartViewController") as CartViewController
       
        self.navigationController?.pushViewController(CartViewController, animated: true)
      
        
        
    }
    

    @IBOutlet weak var BuyButton: UIButton!
    //BuyProductButtonAction
    @IBAction func BuyProductAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let OrderSummaryController = storyboard.instantiateViewController(identifier: "OrderSummaryController") as OrderSummaryController
        let navigationcontroller = UINavigationController(rootViewController: OrderSummaryController)
        self.navigationController?.pushViewController(OrderSummaryController, animated: true)
        navigationcontroller.modalPresentationStyle = .fullScreen
        
    }
    //UIButtons&UILabel
    @IBOutlet weak var BuyProductAction: UIButton!
    
    @IBOutlet weak var DiscriptionLabel: UILabel!
    
   
    
    @IBOutlet weak var FavouriteButton: UIButton!
    
    @IBOutlet weak var CartButton: UIButton!
    override func viewDidLoad() {
        pName.text = productName
        productPriceLabel.text = price
        descriptionLabel.text = Description
        productRating.text = rating
        
    
        FavouriteButton.setImage(UIImage(named: "fav"), for: .normal)
        FavouriteButton.setImage(UIImage(named: "favfill"), for: .selected)
        FavouriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
        
        ScrollProductPage.contentSize = CGSize(width: 286, height: 1350)
        ScrollProductPage.isScrollEnabled = true
        RecentPageController.frame = CGRect(x: 120, y: 305, width: 150, height: 0)
        self.view.addSubview(RecentPageController)
        RecentPageController.currentPage = 0
        RecentPageController.backgroundColor = .black
       // RecentPageController.numberOfPages = ProductImage.count
        

    }
    
}
extension ProductPage:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.ProductCollectionView {
            return ProductImage.count
        } else if collectionView == self.RecentProductCollectionView {
            return RecentImage.count
            
           
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.ProductCollectionView {
            let cell1 = ProductCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as! ProductCollectionViewCell
         //   cell1.ProductImage.image = UIImage(named: ProductImage[indexPath.row])
        
            cell1.ProductImage.image = image
           
              
            return cell1
        } else if collectionView == self.RecentProductCollectionView {
            let cell2 = RecentProductCollectionView.dequeueReusableCell(withReuseIdentifier: "RecentProductCell", for: indexPath) as! RecentCollectionViewCell
            cell2.RecentImage.image = UIImage(named: RecentImage[indexPath.row])
            cell2.RecentLabel.text = RecentLabel[indexPath.row]
            return cell2
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == self.ProductCollectionView {
            RecentPageController.currentPage = indexPath.row
        }
       
    }
}

