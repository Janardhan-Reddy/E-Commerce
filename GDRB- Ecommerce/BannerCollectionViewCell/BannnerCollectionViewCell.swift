//
//  BannnerCollectionViewCell.swift
//  t2H
//
//  Created by Pravin Kumar on 13/02/24.
//

import UIKit

class BannnerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bannerBackgroundView: UIView!
    
    @IBOutlet weak var bannerImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bannerBackgroundView.layer.cornerRadius = 5
        bannerBackgroundView.layer.masksToBounds = true
        bannerImageView.layer.cornerRadius = 5
        bannerImageView.layer.masksToBounds = true
    }

}
