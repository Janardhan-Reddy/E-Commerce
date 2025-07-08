//
//  HomeViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
import SideMenu

class HomeViewController:UIViewController, UINavigationBarDelegate{
  

  
    var menu: SideMenuNavigationController?
    
    
    
    var viewModel : HomeViewModel = HomeViewModel()
    
    var topoffers: [TopOffer]?
    var collections: [Collections]?

    var banners: [Banner]?
    
    @IBOutlet weak var MenuButton: UIButton!
 
    //MenuButtonAction
    @IBAction func MenuAction() {
        present(menu!,animated: true)
        
        
    }
    
    //UIImaageView & UILabels & UIScrollView
    @IBOutlet weak var trackingImageView: UIImageView!
    
    @IBOutlet weak var Scroll: UIScrollView!
    
    var fashionImage:[String] = ["fashion","fashion2","fashion3","fashion4","fashion5","fashion6","fashion","fashion2","fashion3","fashion4"]
    
    
    
    let RecentImage :[String] = ["image14","image15","image16","image17","image18"]
    
    
    let RecentLabel:[String]  = ["Olive Oil","Dolo650","Adidas Blizzers","Raymond Suit","iphone14"]
    
    let RecommendedImages = ["Mouse","AlmondOil", "Tshirrt","FaceWash"]
    let RecommendedTitles = ["Hp  300 Wired Plug", "Dabur Almond Hair Oil", "Leotude Men’s T-shirt", "Weleda Baby Calendu.."]
    let discounts = ["47", "32", "50", "17"]
    let originalPrice = ["269", "200","400","300"]
    let discountedPrice = ["269", "169", "369", "269"]
    
    

    
    @IBOutlet weak var ProductCategoryClnView: UICollectionView!
    {
        didSet{
            ProductCategoryClnView.delegate = self
            ProductCategoryClnView.dataSource = self
        }
    }
    
    @IBOutlet weak var topOffersClnView: UICollectionView!{
        didSet{
            topOffersClnView.delegate = self
            topOffersClnView.dataSource = self
        }
    }
    
    
    @IBOutlet weak var topPagination: UIPageControl!
    
    
    @IBOutlet weak var topBannerClnView: BannerCollectionView!{
        didSet{
            topBannerClnView.loadConnectionView(inController: self)
        }
    }
   
    
    

    
    @IBOutlet weak var recommendedCollectionView: UICollectionView!{
        didSet{
            recommendedCollectionView.delegate = self
            recommendedCollectionView.dataSource = self
        }
    }
    
    
    @IBOutlet weak var topOptionsClnViewHeight: NSLayoutConstraint!
    
    private func navigationSetup(){
      
        let navigationButton = UIButton(type: .system)
        navigationButton.setImage(UIImage(named: "menu4"), for: .normal)
        navigationButton.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        navigationButton.addTarget(self, action: #selector(navigationAction), for: .touchUpInside)
        self.view.addSubview(navigationButton)
    }
    @objc func navigationAction(){
        present(menu!,animated: true)
    }
   
    

   

   
    
    override func viewDidLoad() {
      
       
       
     
        
       
        //Hide navigation bar
//        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
//       self.navigationController!.navigationBar.shadowImage = UIImage()
//        self.navigationController!.navigationBar.isTranslucent = true
//        navigationItem.setHidesBackButton(true, animated: true)
//        
       
        //uibarbutton item
        let leftButton = UIBarButtonItem(title: "abc", style: .plain, target: self, action: #selector(HomeViewController.MenuAction))
        let navigationItem = UINavigationItem()
        navigationItem.titleView = UIImageView(image: UIImage(named: "menu4"))
        navigationItem.leftBarButtonItem = leftButton
        
        //scroll View
//        Scroll.translatesAutoresizingMaskIntoConstraints = true
//        Scroll.showsVerticalScrollIndicator = true
//        Scroll.alwaysBounceVertical = true
//        Scroll.isScrollEnabled = true
//        Scroll.isUserInteractionEnabled = true
//        Scroll.contentSize = CGSize(width: 286, height: 1100)
        
        topOffersClnView.register(
          UINib(nibName: "SeasonSaleCollectionViewCell", bundle: nil),
          forCellWithReuseIdentifier: "SeasonSaleCollectionViewCell"
        )
        recommendedCollectionView.register(
          UINib(nibName: "RecomandedCollectionViewCell", bundle: nil),
          forCellWithReuseIdentifier: "RecomandedCollectionViewCell"
        )
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 100) // adjust to fit
        layout.scrollDirection = .horizontal
        ProductCategoryClnView.collectionViewLayout = layout
        
       //sale layout
        let saleLayout = UICollectionViewFlowLayout()
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = 5
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        let width = (topOffersClnView.bounds.width - totalSpacing) / numberOfItemsPerRow

        saleLayout.itemSize = CGSize(width: width, height: width * 1.25)
        saleLayout.minimumInteritemSpacing = spacing
        saleLayout.minimumLineSpacing = spacing
        saleLayout.scrollDirection = .vertical

        topOffersClnView.collectionViewLayout = saleLayout
        
        
        setupRecommededFlowLayout()
        fetchHomePageContent()
        self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .blue, titleColor: .white)
                
        self.title  = "Home"
        //insert Data of HomeCategoryDataBase
   
        MenuButton.setImage(UIImage(named: "menu4"), for: .normal)
        menu = SideMenuNavigationController(rootViewController:MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = menu
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.tabBarController?.navigationItem.hidesBackButton = true
     
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    
    
    func setupRecommededFlowLayout(){
        let recommendedLayout = UICollectionViewFlowLayout()

        let recommendedItemsPerRow: CGFloat = 2
        let recommendedSpacing: CGFloat = 5

        let totalSpacing = (recommendedItemsPerRow - 1) * recommendedSpacing
        let collectionViewWidth = recommendedCollectionView.bounds.width
        let recommendedItemWidth = (collectionViewWidth - totalSpacing) / recommendedItemsPerRow

        recommendedLayout.itemSize = CGSize(width: recommendedItemWidth, height: recommendedItemWidth * 1.4)
        recommendedLayout.minimumInteritemSpacing = recommendedSpacing
        recommendedLayout.minimumLineSpacing = recommendedSpacing
        recommendedLayout.scrollDirection = .vertical

        recommendedCollectionView.collectionViewLayout = recommendedLayout

    }
    
    private func fetchHomePageContent(){
        LoadingView.shared.show()
        viewModel.loadHomePageItems { homeResponse, error in
            if let response = homeResponse{
                if let topOffers = response.topoffers{
                    self.topoffers = topOffers
                    self.collections = response.collections
                    
                    if let banners = response.banners{
                        self.banners = banners
                        self.topBannerClnView.loadData(banners: banners)
                      

                    }
                    let productCount = topOffers.count
                    let cellHeight: CGFloat = 160
                    let rows = ceil(CGFloat(productCount) / 3.0)
                    
                    DispatchQueue.main.async{
                        self.topOptionsClnViewHeight.constant = rows * cellHeight
                        self.view.layoutIfNeeded()
                        self.topOffersClnView.reloadData()
                        self.ProductCategoryClnView.reloadData()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            LoadingView.shared.hide()
                        }

                       
                    }
                    
                }
                
            }
            
        }
    }
    
}
//extension of HomeViewController
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.ProductCategoryClnView {
            return collections?.count ?? 0
        } else if collectionView == self.topOffersClnView {
            return topoffers?.count ?? 0
        }else if collectionView == self.recommendedCollectionView{
            return RecommendedImages.count
        }
        return 0
    }

    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.ProductCategoryClnView{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let ProductDetailsController = storyboard.instantiateViewController(identifier: "ProductDetailsController") as ProductDetailsController
            ProductDetailsController.TitleName = collections?[indexPath.row].name ?? "-"
            self.navigationController?.pushViewController(ProductDetailsController, animated: true)
            
        }
    }
    
      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         if collectionView == self.ProductCategoryClnView {
            let cell = ProductCategoryClnView.dequeueReusableCell(withReuseIdentifier: "SecondCollectionViewCell", for: indexPath) as! SecondCollectionViewCell
             
             cell.CategoryImage.image = UIImage(systemName: "photo")?.withTintColor(UIColor(named: "DefaultBlue") ?? .blue)
             
             if let logo = collections?[indexPath.row].image_path?.replacingOccurrences(of: "\\", with: "/") {
                 let baseurl = "https://gdrbpractice.gdrbtechnologies.com/"
                 UIImage.fetchImage(from: logo,baseURL: baseurl) { image in
                     DispatchQueue.main.async {
                         if let fetchedImage = image {
                             cell.CategoryImage.image = fetchedImage
                         } else {
                             print("No image fetched for:", logo)
                         }
                     }
                 }
             }
             
            cell.CategoryLabel.text = collections?[indexPath.row].name ?? "-"
            
            return cell
        } else if collectionView == self.topOffersClnView {
            let cell3 = topOffersClnView.dequeueReusableCell(withReuseIdentifier: "SeasonSaleCollectionViewCell", for: indexPath) as! SeasonSaleCollectionViewCell
            cell3.saleMainIMG.image = UIImage(systemName: "photo")?.withTintColor(UIColor(named: "DefaultBlue") ?? .blue)
            if let logo = topoffers?[indexPath.row].image_path?.replacingOccurrences(of: "\\", with: "/") {
                let baseurl = "https://gdrbpractice.gdrbtechnologies.com/"
                UIImage.fetchImage(from: logo,baseURL: baseurl) { image in
                    DispatchQueue.main.async {
                        if let fetchedImage = image {
                            cell3.saleMainIMG.image = fetchedImage
                        } else {
                            print("No image fetched for:", logo)
                        }
                    }
                }
            }

            cell3.saleCategoryText.text = topoffers?[indexPath.row].title
            return cell3
        }else  if collectionView == self.recommendedCollectionView{
            let cell = recommendedCollectionView.dequeueReusableCell(withReuseIdentifier: "RecomandedCollectionViewCell", for: indexPath) as! RecomandedCollectionViewCell
            cell.ProductImage.image = UIImage(named: RecommendedImages[indexPath.row])
            cell.Productname.text = RecommendedTitles[indexPath.row]
            cell.offerPercentage.text = "-" + discounts[indexPath.row] + "%"
            cell.finalPrice.text = discountedPrice[indexPath.row]
            cell.originalSlashedPrice.text = originalPrice[indexPath.row]
            cell.lastBoughtCount.text = "1k + bought in past month"
            
            
            return cell
        }
        return UICollectionViewCell()
    }
    
}
