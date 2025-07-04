//
//  SideMenuController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 20/12/22.
//

import UIKit
import SideMenu
class SideMenuController:UIViewController{
    //UIButton
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBAction func MenuAction(_ sender: Any) {
        present(menu!,animated: true)
       
    }
    //assigning a variable to SideMenuNavigationController
    var menu: SideMenuNavigationController?
    override func viewDidLoad() {
        //setHidesBackButton of navigationItem
        self.navigationItem.setHidesBackButton(true, animated: false)
        //side menu functionalities
        menu = SideMenuNavigationController(rootViewController:MenuListController())
        menu?.leftSide = true
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        SideMenuManager.default.leftMenuNavigationController = menu
        
        super.viewDidLoad()
        
    }
    
}
class MenuListController:UITableViewController{
    let WhiteColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1)
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
    }
    override func viewDidLoad() {
        //UIImageView
        let cellImage = UIImageView(frame: CGRect(x: 40, y: -54, width: 25, height: 25))
        cellImage.image = UIImage(named: "image")
        self.view.addSubview(cellImage)
        //UILabel
        let label  = UILabel(frame: CGRect(x: 70, y: -54, width: 100, height: 25))
        label.text = "Welcome!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        self.view.addSubview(label)
        
        
        super.viewDidLoad()
        //tableView
        tableView.backgroundColor = WhiteColor
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
    }
    //sideMenu element names
    var items = ["Wishlist","My Orders","My Cart","Share App","Settings","Logout"]
    //sideMenu element names of UIImage
    var MenuIcon : [UIImage] = [UIImage(named: "wishlisticon")!,
                                UIImage(named: "myorders")!,
                                UIImage(named: "mycart")!,
                                UIImage(named: "Refer")!,
                                UIImage(named: "setting")!,
                                UIImage(named: "logout")!,]
    //tableView delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        
        cell.imageView?.image = MenuIcon[indexPath.row]
        cell.backgroundColor = WhiteColor
        cell.textLabel?.textColor = .black
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
         
        if indexPath == IndexPath(row: 0, section: 0){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let CartViewController = storyboard.instantiateViewController(identifier: "CartViewController") as CartViewController
            self.navigationController?.pushViewController(CartViewController, animated: true)

            
            
        }
        if indexPath == IndexPath(row: 1, section: 0){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MyOrdersViewController = storyboard.instantiateViewController(identifier: "MyOrdersViewController") as MyOrdersViewController
            self.navigationController?.pushViewController(MyOrdersViewController, animated: true)

            
        }
        if indexPath == IndexPath(row: 2, section: 0){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let CartViewController = storyboard.instantiateViewController(identifier: "CartViewController") as CartViewController
            self.navigationController?.pushViewController(CartViewController, animated: true)

            
            
        }
        if indexPath == IndexPath(row: 3, section: 0){
            let activityController = UIActivityViewController(activityItems: [
                "GDRB TECHNOLOGIES PVT LTD",
              
                
            ], applicationActivities: nil)
            present(activityController,animated: true)
            
           
        }
        
        if indexPath == IndexPath(row: 4, section: 0){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let Settings = storyboard.instantiateViewController(identifier: "Settings") as Settings
            self.navigationController?.pushViewController(Settings, animated: true)

            
        }
        if indexPath == IndexPath(row: 5, section: 0) {
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           let LoginController = storyboard.instantiateViewController(identifier: "LoginController") as LoginController
           self.navigationController?.pushViewController(LoginController, animated: true)

       }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

