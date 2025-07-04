//
//  ViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//
//
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        let login  = UserDefaults.standard.bool(forKey: "isLogin")
        if login == true{
            let home = self.storyboard?.instantiateViewController(withIdentifier: "Tabbar")
            self.navigationController?.pushViewController(home!, animated: true)

        }
        else {
            let LoginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginController")
            self.navigationController?.pushViewController(LoginController!, animated: true)

        }
       
    }


}


