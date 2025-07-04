//
//  RecomandedCollectionViewCell.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 30/06/25.
//

import UIKit

class RecomandedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ProductImage: UIImageView!
    
    
    @IBOutlet weak var Productname: UILabel!
    
    
    @IBOutlet weak var offerPercentage: UILabel!
    
    
    @IBOutlet weak var finalPrice: UILabel!
    
    
    @IBOutlet weak var originalSlashedPrice: UILabel!
    
    
    @IBOutlet weak var lastBoughtCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

class RectangularShadowView: UIView {

    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 0 // Rounded corners for a smoother shadow appearance
        self.layer.masksToBounds = false

        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor

        self.layer.shadowColor = UIColor.black.cgColor // Darker shadow for better contrast
        self.layer.shadowOpacity = 0.4 // Lower opacity for a softer shadow
        self.layer.shadowOffset = CGSize(width: 0, height: 5) // Slightly more vertical shadow
        self.layer.shadowRadius = 6 // Reduced radius for a more subtle blur

        // Set a shadowPath to avoid performance issues
        let shadowRect = CGRect(x: 0, y: bounds.height - 8, width: bounds.width, height: 8) // Adjusted for a larger shadow effect
        self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath

        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}



extension UITableView {
    func registerCells(cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        }
    }
}

extension UICollectionView {
    func registerCells(cellIdentifiers: [String]) {
        for identifier in cellIdentifiers {
            self.register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
        }
    }
}
