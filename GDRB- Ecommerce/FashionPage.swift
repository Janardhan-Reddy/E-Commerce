//
//  FashionPage.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 01/12/22.
//

import UIKit
class FashionPage:UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 38
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = FashionCollectionView.dequeueReusableCell(withReuseIdentifier: "FashionCell", for: indexPath)
        return cell
    }
    
    
    @IBOutlet weak var FashionCollectionView: UICollectionView!
    override func viewDidLoad() {
        self.title = "Fashione"
    
    }
}
