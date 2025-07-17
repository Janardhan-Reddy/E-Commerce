//
//  BannerCollectionView.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 01/07/25.
//
import UIKit

class BannerCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout , UIScrollViewDelegate{
    
    // MARK: - Variable Declaration
    var controller: HomeViewController!
    var timer: Timer?
    var currentCellIndex = 0
    var banners: [Banner]?
    private var bannerImages: [UIImage?] = []
  
    // MARK: - Setup
    func loadConnectionView(inController: HomeViewController) {
        self.delegate = self
        self.dataSource = self
        self.controller = inController
        
        self.isPagingEnabled = false
        self.decelerationRate = .fast

       
        self.showsHorizontalScrollIndicator = false
        self.registerCells(cellIdentifiers: ["BannnerCollectionViewCell"])
       
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
      
        
    }
    
    
    func loadData(banners: [Banner]?) {
      self.banners = banners
      let count = banners?.count ?? 0
      bannerImages = Array<UIImage?>(repeating: nil, count: count)
      DispatchQueue.main.async {
        self.controller.topPagination.numberOfPages = count
      
        self.reloadData()
      }

      // Kick off all the image fetches exactly once:
      for (i, banner) in (banners ?? []).enumerated() {
        let path = banner.image_path?.replacingOccurrences(of: "\\", with: "/") ?? ""
          let baseurl = "https://gdrbpractice.gdrbtechnologies.com/"
          UIImage.fetchImage(from: path,baseURL: baseurl ) { [weak self] image in
          guard let self = self else { return }
          DispatchQueue.main.async {
            self.bannerImages[i] = image
            // Option A: reload just that one cell:
            self.reloadItems(at: [IndexPath(item: i, section: 0)])
            // Option B: or reload the whole collection once at the end
          }
        }
      }

      // start auto-scrolling after a short delay
      DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        self?.startTimer()
      }
    }
    
    // MARK: - Timer
    func startTimer() {
       
            self.timer = Timer.scheduledTimer(timeInterval: 5,
                                              target: self,
                                              selector: #selector(self.moveToNextIndex),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    deinit {
        timer?.invalidate()
    }
    
    @objc func moveToNextIndex() {
        guard let bannersCount = banners?.count, bannersCount > 1 else { return }
        
        // Increment the index and ensure it doesn't exceed the bounds
        currentCellIndex = (currentCellIndex + 1) % bannersCount
        
        DispatchQueue.main.async {
            // Scroll to the valid index
            self.scrollToItem(at: IndexPath(row: self.currentCellIndex, section: 0), at: .left, animated: true)
        }
        
        controller.topPagination.currentPage = currentCellIndex
    }

    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Calculate the current page index
        let pageIndex = Int(round(scrollView.contentOffset.x / scrollView.frame.width))
        
        // Make sure we only update pagination if the page index has changed
        if pageIndex != controller.topPagination.currentPage {
            controller.topPagination.currentPage = pageIndex
        }
        
      
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                    withVelocity velocity: CGPoint,
                                    targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        // Prevent native momentum scrolling
        targetContentOffset.pointee = scrollView.contentOffset

        let pageWidth = scrollView.frame.width
        let currentOffset = scrollView.contentOffset.x
        let targetIndex = Int(round(currentOffset / pageWidth))

        let clampedIndex = max(0, min(targetIndex, (banners?.count ?? 1) - 1))

        // Scroll like auto slider
        self.scrollToItem(at: IndexPath(item: clampedIndex, section: 0), at: .left, animated: true)

        // Update index and page control
        currentCellIndex = clampedIndex
        controller.topPagination.currentPage = clampedIndex
    }


    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // Invalidate timer when user starts dragging
        timer?.invalidate()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // Restart timer when user ends dragging
        startTimer()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Update current index when scrolling ends
        currentCellIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        controller.topPagination.currentPage = currentCellIndex
    }

    
    // MARK: - CollectionView DataSource and Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners?.count ?? 0
    }
    
    func collectionView(_ cv: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = cv.dequeueReusableCell(withReuseIdentifier: "BannnerCollectionViewCell",
                                        for: indexPath) as! BannnerCollectionViewCell
      cell.contentView.isUserInteractionEnabled = false

      if let img = bannerImages[indexPath.row] {
        // we already fetched & cached it
          cell.bannerImageView.image  = resizeAndFill(image: img, targetSize: self.bounds.size)
         // resizeImage(image:img , targetSize: self.bounds.size)
        cell.bannerImageView.contentMode = .scaleAspectFill
      } else {
        // still loading: show placeholder
        cell.bannerImageView.image   = nil
          cell.bannerImageView.contentMode = .scaleAspectFill
      }

      return cell
    }

    
    // MARK: - Layout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func resizeAndFill(image: UIImage, targetSize: CGSize) -> UIImage {
        let sourceSize = image.size
        
        // 1) Figure out scale so the image fully covers the target
        let widthRatio  = targetSize.width  / sourceSize.width
        let heightRatio = targetSize.height / sourceSize.height
        let scaleRatio = max(widthRatio, heightRatio)      // <-- aspect‐fill
        
        // 2) Compute the scaled image size
        let scaledSize = CGSize(width: sourceSize.width * scaleRatio,
                                height: sourceSize.height * scaleRatio)
        
        // 3) Center it in the target rectangle
        let xOffset = (targetSize.width  - scaledSize.width)  / 2.0
        let yOffset = (targetSize.height - scaledSize.height) / 2.0
        let drawRect = CGRect(origin: CGPoint(x: xOffset, y: yOffset),
                              size: scaledSize)
        
        // 4) Render into a new context of the exact targetSize
        UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
        image.draw(in: drawRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }

}
