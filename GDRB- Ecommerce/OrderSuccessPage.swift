//
//  OrderSuccessPage.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 02/12/22.
//


import UIKit
class OrderSuccessPage:UIViewController{
    //BackButtonAction
    @IBAction func BackAction(_ sender: Any) {
        //push navigationController
        let TabVc = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")
        self.navigationController?.pushViewController(TabVc!, animated: true)
        
    }
    
    override func viewDidLoad() {
        //HidesBackButton of navigationItem
       // self.navigationItem.setHidesBackButton(true, animated: true)
        

    }
}

