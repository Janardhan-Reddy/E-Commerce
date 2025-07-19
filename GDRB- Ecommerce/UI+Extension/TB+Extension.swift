//
//  TB+Extension.swift
//  GDRB- Ecommerce
//
//  Created by Pravin Kumar on 19/07/25.
//

import UIKit
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
