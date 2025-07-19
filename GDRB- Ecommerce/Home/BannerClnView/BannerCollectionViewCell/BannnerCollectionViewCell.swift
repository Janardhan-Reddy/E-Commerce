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

           // Ensure the imageView stretches to fill the cell
        bannerImageView.contentMode = .scaleAspectFit
         
       }

       override func layoutSubviews() {
           super.layoutSubviews()

           // If you're not using Auto Layout (Storyboard/XIB), set frame manually:
           bannerImageView.frame = contentView.bounds
       }
    
  

}
