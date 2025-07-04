//
//  ContainerViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 14/12/22.
//

import UIKit
protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class ContainerViewController: UIViewController {
    weak var delegate: HomeViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage (systemName: "list.dash"),
        style: .done, target: self, action: #selector (didTapMenuButton))
        
        super.viewDidLoad()
        
        
    }
    @objc func didTapMenuButton () {
        
        print("tapped")
        delegate?.didTapMenuButton()
    
    }
}

    
    

    

    


