//
//  ProductDetailsController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 27/11/22.
//

import UIKit

class ProductDetailsController:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    
   

    var TitleName:String?
    var viewModel = ProductViewModel()
    var productData : ProductsResponse?
    

    var allProducts: [Product] = []
    var filteredProducts: [Product] = []

    

    
    @IBOutlet weak var topNavItemCategories: UICollectionView!
    
    @IBOutlet weak var productItemsClnView: UICollectionView!
    
    @IBOutlet weak var productClnViewHeight: NSLayoutConstraint!
    
    private func loadProducts(productCaregoryname: String){
        viewModel.getProduct(productName: productCaregoryname) { productDataResponse, error in
            guard  error == nil else{
                return
            }
            
            if let productDataResponse = productDataResponse{
                self.productData = productDataResponse
                
                self.allProducts = productDataResponse.data?.products ?? []
                  self.filteredProducts = self.allProducts
                
                let productCount = self.filteredProducts.count
                let cellHeight: CGFloat = 220
                let rows = ceil(CGFloat(productCount) / 2.0)
                DispatchQueue.main.async {
                    self.productClnViewHeight.constant = rows * cellHeight
                    self.view.layoutIfNeeded()
                    self.topNavItemCategories.reloadData()
                    self.productItemsClnView.reloadData()
                }
              
            }
            
            
        }
        
    }
    
    
  
    
    override func viewDidLoad() {

        self.title = TitleName
     
        topNavItemCategories.delegate = self
        topNavItemCategories.dataSource = self
        productItemsClnView.delegate = self
        productItemsClnView.dataSource = self
        if let title = TitleName{
            loadProducts(productCaregoryname: title.lowercased())
        }
        setupRecommededFlowLayout()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 120) // adjust to fit
        layout.scrollDirection = .horizontal
        topNavItemCategories.collectionViewLayout = layout
        
        
      
    }
    
    func setupRecommededFlowLayout(){
        let recommendedLayout = UICollectionViewFlowLayout()

        let recommendedItemsPerRow: CGFloat = 2
        let recommendedSpacing: CGFloat = 5

        let totalSpacing = (recommendedItemsPerRow - 1) * recommendedSpacing
        let collectionViewWidth = productItemsClnView.bounds.width
        let recommendedItemWidth = (collectionViewWidth - totalSpacing) / recommendedItemsPerRow

        recommendedLayout.itemSize = CGSize(width: recommendedItemWidth, height: recommendedItemWidth * 1.1)
        recommendedLayout.minimumInteritemSpacing = recommendedSpacing
        recommendedLayout.minimumLineSpacing = 15
        recommendedLayout.scrollDirection = .vertical

        productItemsClnView.collectionViewLayout = recommendedLayout

    }
    
    
     
     //UICollectionView delegate methods
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == topNavItemCategories{
             return productData?.navbarHeadings?.count ?? 0
         } else if collectionView == productItemsClnView {
             return filteredProducts.count
         }
         return 0
     }
     

     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == topNavItemCategories{
             let cell = topNavItemCategories.dequeueReusableCell(withReuseIdentifier: "ProductCategortCollectionViewCell", for: indexPath) as! ProductCategortCollectionViewCell
             
             cell.productNameLabel.text = productData?.navbarHeadings?[indexPath.row].subName ?? "-"
             
             return cell
         }else if collectionView == productItemsClnView{
             let cell = productItemsClnView.dequeueReusableCell(withReuseIdentifier: "ProductItemsCollectionViewCell", for: indexPath) as! ProductItemsCollectionViewCell
             cell.productNameLabel.text = productData?.data?.products?[indexPath.row].prdName ?? "-"
             cell.productPriceLabel.text = productData?.data?.products?[indexPath.row].sellingPrice ?? "-"
             
             if let logo = productData?.data?.products?[indexPath.row].firstImage?.replacingOccurrences(of: "\\", with: "/") {
                 let baseurl = "https://gdrbpractice.gdrbtechnologies.com/"
                 UIImage.fetchImage(from: logo,baseURL: baseurl) { image in
                     DispatchQueue.main.async {
                         if let fetchedImage = image {
                             cell.productImage.image = fetchedImage
                         } else {
                             print("No image fetched for:", logo)
                         }
                     }
                 }
             }
             
             return cell
         }
         return UICollectionViewCell()
     }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topNavItemCategories {
            guard let selectedSubName = productData?.navbarHeadings?[indexPath.row].subName?.lowercased(),
            let mainCategory = TitleName?.lowercased() else { return }

            let categoryMap = getCategoryMapping(for: mainCategory)

            if let matchingSubCatIds = categoryMap[selectedSubName] {
                // Filter allProducts using the mapped subcategory IDs
                filteredProducts = allProducts.filter { product in
                    if let subCatId = product.prdSubCatId {
                        return matchingSubCatIds.contains(subCatId)
                    }
                    return false
                }
            } else {
                // Fallback to show all if no matching entry found
                filteredProducts = allProducts
            }

            // Recalculate dynamic height
            let productCount = filteredProducts.count
            let cellHeight: CGFloat = 220
            let rows = ceil(CGFloat(productCount) / 2.0)

            DispatchQueue.main.async {
                self.productClnViewHeight.constant = rows * cellHeight
                self.view.layoutIfNeeded()
                self.productItemsClnView.reloadData()
            }
        } else if collectionView == productItemsClnView {
           
        }
    }


    
    
    
    func getCategoryMapping(for categoryType: String) -> [String: [Int]] {
            switch categoryType {
            case "electronics":
                return [
                    "all": [1, 2, 3, 4, 5, 6, 7],
                    "mobile": [1],
                    "laptop": [2],
                    "watches": [3],
                    "accessories": [4],
                    "tv & projectors": [5],
                    "ac & coolers": [6],
                    "refrigerator": [7]
                ]
            case "fashion":
                return [
                    "all": [3, 8, 9, 10, 11, 12, 13, 14],
                    "cosmetics": [8],
                    "shirts": [9],
                    "t-shirts": [10],
                    "jeans": [11],
                    "shoes": [12],
                    "bags": [13],
                    "wallets": [14]
                ]
            case "groceries":
                return [
                    "all": [3, 15, 16, 17, 18, 19, 20, 21],
                    "oil": [15],
                    "rice": [16],
                    "general items": [17],
                    "bath items": [18],
                    "dairy & eggs": [19],
                    "kitchen items": [20],
                    "bakery foods": [21]
                ]
            case "medicine":
                return [
                    "all": [3, 22, 23, 24, 25, 26, 27, 28],
                    "stomach care": [22],
                    "ent": [23],
                    "kidney care": [24],
                    "cardiac care": [25],
                    "diabetic": [26],
                    "general medicine": [27],
                    "optical": [28]
                ]
            default:
                return [:]
            }
        }
     
    
}

class ProductCategortCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var productImage: CircularImageView!
    
    
    @IBOutlet weak var productNameLabel: UILabel!
    
}


class ProductItemsCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var productImage: UIImageView!
    
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    
}
