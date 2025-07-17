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

    var SelectedIndex: IndexPath?

    
    @IBOutlet weak var topNavItemCategories: UICollectionView!
    
    @IBOutlet weak var productItemsClnView: UICollectionView!
    
    
    private func loadProducts(productCaregoryname: String){
        LoadingView.shared.show()
        viewModel.getProduct(productName: productCaregoryname) { productDataResponse, error in
            guard  error == nil else{
                return
            }
            
            if let productDataResponse = productDataResponse{
                self.productData = productDataResponse
                
                self.allProducts = productDataResponse.data?.products ?? []
                  self.filteredProducts = self.allProducts
                
             
                DispatchQueue.main.async {
                    LoadingView.shared.hide()
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
        setupRecommendedFlowLayout()
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80) 
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 3
        topNavItemCategories.collectionViewLayout = layout
        
        
      
    }
    
    func setupRecommendedFlowLayout() {
        let recommendedLayout = UICollectionViewFlowLayout()

        let recommendedItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 3

        let totalSpacing = (recommendedItemsPerRow - 1) * spacing
        let collectionViewWidth = productItemsClnView.bounds.width
        let itemWidth = (collectionViewWidth - totalSpacing) / recommendedItemsPerRow

        recommendedLayout.itemSize = CGSize(width: itemWidth * 1.02 , height: itemWidth * 1.1)
        recommendedLayout.minimumInteritemSpacing = spacing
        recommendedLayout.minimumLineSpacing = spacing
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
             
             cell.productNameLabel.text = productData?.navbarHeadings?[indexPath.row].subName?.capitalized ?? "-"
             if SelectedIndex == indexPath {
                 cell.productNameLabel.font = UIFont.systemFont(ofSize: 13)
                 cell.productNameLabel.textColor = .red
             }else{
                 cell.productNameLabel.font = UIFont.systemFont(ofSize: 11)
                 cell.productNameLabel.textColor = .black
             }
             
             return cell
         }else if collectionView == productItemsClnView{
             let cell = productItemsClnView.dequeueReusableCell(withReuseIdentifier: "ProductItemsCollectionViewCell", for: indexPath) as! ProductItemsCollectionViewCell
             cell.productNameLabel.text = filteredProducts[indexPath.row].prdName ?? "-"
             
             let rupeeSymbol = "\u{20B9}"
             let price = filteredProducts[indexPath.row].prdPrice ?? "-"
             cell.productPriceLabel.text = "Price: \(rupeeSymbol)\(price)"
           
             
             if let logo = filteredProducts[indexPath.row].firstImage?.replacingOccurrences(of: "\\", with: "/") {
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
            SelectedIndex = indexPath
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
          

            DispatchQueue.main.async {
                self.topNavItemCategories.reloadData()
                self.productItemsClnView.reloadData()
            }
        } else if collectionView == productItemsClnView {
            let vc = storyboard?.instantiateViewController(withIdentifier: "EachItemVc") as! EachItemVc
            vc.eachItemData = productData?.data?.products?[indexPath.row]
            vc.similarProductData = productData?.data
            self.navigationController?.pushViewController(vc, animated: true)
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



extension UIViewController {
    func setNavigationBarColors(backgroundColor: UIColor, titleColor: UIColor, tintColor: UIColor = .white) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.titleTextAttributes = [.foregroundColor: titleColor]
        appearance.largeTitleTextAttributes = [.foregroundColor: titleColor]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = tintColor
    }
}
