//
//  EachItemVc.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 08/07/25.
//

import UIKit
class EachItemVc: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // MARK: var declaration
    var eachItemData: Product?
    var similarProductData: ProductsData?
    var viewModel = EachItemViewModel()
    
    // MARK: @IBOutlet
    @IBOutlet weak var imagePreviewCollectionview: UICollectionView!
    @IBOutlet weak var imagePreviewPagination: UIPageControl!
    @IBOutlet weak var ProductName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var descriptionTxt: UILabel!
    @IBOutlet weak var similarProductsCollectionView: UICollectionView!
    @IBOutlet weak var colourOptionsClnView: UICollectionView!
    @IBOutlet weak var addtoCartBtn: UIButton!
    @IBOutlet weak var buyNowBtn: UIButton!
    @IBAction func addToCartPressed(_ sender: UIButton) {
        addtoCart()
    }
    @IBAction func buyNowPressed(_ sender: UIButton) {
        proceedBuyAction()
    }
    @IBAction func onWishListPressed(_ sender: UIButton) {
        
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        } else {
            LoadingView.shared.show()
            addToWishList(sender: sender)
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonUI()
        setupCollectionView()
        ProductName.text = eachItemData?.prdName ?? "-"
        let rupeeSymbol = "\u{20B9}"
        let price = eachItemData?.prdPrice ?? "-"
        productPrice.text = "\(rupeeSymbol)\(price)"
        imagePreviewPagination.numberOfPages = eachItemData?.images?.count ?? 0
        descriptionTxt.text = eachItemData?.prdDescription ?? "-"
        setupLayoutForSimilarProductView()
        setupRecommededFlowLayout()
        setupLayoutForColorOptionsClnView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            
            self?.similarProductsCollectionView.reloadData()
        }
    }
   
    // MARK: Private func
    private func navigateToLoginScreen(){
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

    private func addToWishList(sender: UIButton){
        guard let productId = eachItemData?.prdId else { return }

        viewModel.addProductToWishList(prd_id: String(productId), quantity: "1") { response, error in
            guard error == nil else { return }
            LoadingView.shared.hide()
            DispatchQueue.main.async {
                if let response = response, response.status == true {
                    
                    self.showToast(message: response.message ?? "Added to Wishlist successfully", iconName: "cart.badge.plus", backgroundColor: .systemGreen)
                    
                    sender.isSelected = true
                    sender.setImage(UIImage(systemName: "heart.fill"), for: .selected)
                } else {
                    self.showAlert(title:  "Failed!", message: "Failed to add to wishlist.")
                    sender.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
        }
    }
    
    private func proceedBuyAction(){
        let billingItem = BillingModel(
            productImage: eachItemData?.firstImage,
            productName: eachItemData?.prdName,
            productPrice: eachItemData?.sellingPrice,
            quantity: 1, orderId: eachItemData?.prdId ?? 0
        )
        
        let billingData = [billingItem]
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "BillingVC") as! BillingVC
        vc.billableItem = billingData
        
        self.navigationController?.pushViewController(vc, animated: true)
            }
    
    private func addtoCart(){
        guard let productId = eachItemData?.prdId else { return }
        LoadingView.shared.show()
        
        let accessToken = UserDefaults.standard.string(forKey: "authToken")
        if accessToken == nil {
            LoadingView.shared.hide()
            navigateToLoginScreen()
        }
        viewModel.addProductToCart(prd_id: String(productId), quantity: "1") { response, error in
            guard error == nil else { return }
            DispatchQueue.main.async {
                LoadingView.shared.hide()
                if let response = response, response.status == true {
                    
                    self.showToast(message: response.message ?? "Added to cart successfully", iconName: "cart.badge.plus", backgroundColor: .systemGreen)
                    
                } else if let response = response, response.status == false{
                    
                    self.showToast(message: response.message ?? "Product already in cart", iconName: "exclamationmark.triangle.fill", backgroundColor: .systemOrange)
                    
                }else{
                    self.showAlert(title:  "Failed!", message:  "Adding Item Failed")
                }
            }
        }
    }
    
    
}

extension EachItemVc{
    
    // MARK: UISetup
    
    private func setupCollectionView(){
        imagePreviewCollectionview.isPagingEnabled = true
        similarProductsCollectionView.isPagingEnabled = true
        imagePreviewCollectionview.delegate = self
        imagePreviewCollectionview.dataSource = self
        similarProductsCollectionView.delegate = self
        similarProductsCollectionView.dataSource = self
        colourOptionsClnView.delegate = self
        colourOptionsClnView.dataSource = self
    }
    
    private func setupButtonUI(){
        
        // MARK: - Add to Cart Button
        addtoCartBtn.clipsToBounds = true
        addtoCartBtn.layer.cornerRadius = 15
        addtoCartBtn.layer.borderWidth = 1
        addtoCartBtn.layer.borderColor = UIColor(named: "DefaultBlue")?.cgColor
        
        // MARK: - Buy Now Button
        buyNowBtn.clipsToBounds = true
        buyNowBtn.layer.cornerRadius = 15
        buyNowBtn.layer.borderWidth = 1
        buyNowBtn.layer.borderColor = UIColor.clear.cgColor
        
    }
    
    
    func setupRecommededFlowLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = imagePreviewCollectionview.bounds.size
        imagePreviewCollectionview.collectionViewLayout = layout
        
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
    
    func setupLayoutForColorOptionsClnView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        
        let numberOfItemsInRow: CGFloat = 2
        let spacing: CGFloat = layout.minimumInteritemSpacing * (numberOfItemsInRow - 1)
        let width = colourOptionsClnView.bounds.width
        let height = colourOptionsClnView.bounds.height
        
        let cellWidth = (width - spacing) / numberOfItemsInRow
        layout.itemSize = CGSize(width: cellWidth, height: height)
        
        colourOptionsClnView.collectionViewLayout = layout
        colourOptionsClnView.showsHorizontalScrollIndicator = false
    }
    
    
}
// MARK: TableView Setup
extension EachItemVc {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == imagePreviewCollectionview {
            return eachItemData?.images?.count ?? 0
        } else if collectionView == similarProductsCollectionView{
            return similarProductData?.products?.count ?? 0
        }else if collectionView == colourOptionsClnView {
            return 2
        }
        return 0
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
        } else if collectionView == similarProductsCollectionView {
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
            cell.itemPrice.text = "\(rupeeSymbol)\(price)"
            
            return cell
        }else if collectionView == colourOptionsClnView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorOptionsClnViewCell", for: indexPath) as! ColorOptionsClnViewCell
            
            cell.imageView.image = UIImage(systemName: "laptopcomputer")
            
            cell.itemColor.text = indexPath.row == 0 ? "Grey" : "Artic Grey"
            
            cell.actualPrice.text = "₹45000"
            
            cell.originalPrice.setStrikethroughPrice("₹76000")
            
            
            return cell
        }else{
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == similarProductsCollectionView{
            self.eachItemData =  similarProductData?.products?[indexPath.row]
            DispatchQueue.main.async {
                self.ProductName.text = self.eachItemData?.prdName ?? "-"
                let rupeeSymbol = "\u{20B9}"
                let price = self.eachItemData?.prdPrice ?? "-"
                self.productPrice.text = "\(rupeeSymbol)\(price)"
                self.descriptionTxt.text = self.eachItemData?.prdDescription ?? "-"
                self.imagePreviewCollectionview.reloadData()
            }
            
            
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == imagePreviewCollectionview {
            let pageIndex = round(scrollView.contentOffset.x / scrollView.frame.width)
            imagePreviewPagination.currentPage = Int(pageIndex)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension EachItemVc{
    // MARK: Alert
    
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
