//
//  ProductCollectionViewCell.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 23/11/22.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    //custome UIImageView&UILabel&UIPageControl
    @IBOutlet weak var ProductImage:UIImageView!
    @IBOutlet weak var ProductName:UILabel!
    @IBOutlet weak var productPrice:UILabel!
    @IBOutlet weak var RecentPageController: UIPageControl!
}
