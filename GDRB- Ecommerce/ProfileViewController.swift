//
//  ProfileViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
class ProfileViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    
    @IBOutlet weak var ProfileImage: UIImageView!
   
    @IBOutlet weak var ProfileMail: UILabel!
    @IBOutlet weak var ProfileName: UILabel!
    var ProfileIcon : [UIImage] = [UIImage(named: "Address")!,
                                    UIImage(named: "wishlisticon")!,
                                    UIImage(named: "myorders")!,
                                   
                                   UIImage(named: "setting")!,
                                   UIImage(named: "Refer")!,
                                   UIImage(named: "logout")!,]
  
    let ProfileLabel:[String] = ["Address","Wishlist","Myorders","Settings","Refer a friend","Logout"]
    @IBAction func Logout(_ sender: Any) {

    }

    //UITableView
    @IBOutlet weak var ProfileTableView: UITableView!
   // tableView delegate methods
  
    override func viewDidLoad() {
        if let storedEmail = UserDefaults.standard.string(forKey: "userEmail") {
            // Use the storedEmail value as needed
            ProfileName.text = storedEmail
            print(storedEmail)
        }
        self.title = "My Profile"
        self.setNavigationBarColors(backgroundColor: UIColor(named: "DefaultBlue") ?? .red, titleColor: .white)
     
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell",for: indexPath) as! CustomeTableViewCell
        cell.ProfileLabel?.text = ProfileLabel[indexPath.row]
        cell.ProfileIcon.image = ProfileIcon[indexPath.row]
       //cell.accessoryType = .checkmark
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath == IndexPath(row: 5, section: 0){
            UserDefaults.standard.set(false, forKey: "isLogin")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let LoginController = storyboard.instantiateViewController(identifier: "LoginController") as LoginController
          
            self.navigationController?.pushViewController(LoginController, animated: true)
          
          
            
        }
        else if indexPath == IndexPath(row: 0, section: 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let SavedAddress = storyboard.instantiateViewController(identifier: "SavedAddress") as SavedAddress
         
            self.navigationController?.pushViewController(SavedAddress, animated: true)

            
        }
        
        else if indexPath == IndexPath(row: 1, section: 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let WishList = storyboard.instantiateViewController(identifier: "WishList") as WishList
            self.navigationController?.pushViewController(WishList, animated: true)

            
        }
        else if indexPath == IndexPath(row: 2, section: 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let MyOrdersViewController = storyboard.instantiateViewController(identifier: "MyOrdersViewController") as MyOrdersViewController
          
            self.navigationController?.pushViewController(MyOrdersViewController, animated: true)
                        
        }
        else if indexPath == IndexPath(row: 3, section: 0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let Settings = storyboard.instantiateViewController(identifier: "Settings") as Settings
          
            self.navigationController?.pushViewController(Settings, animated: true)
      
            
        }
        else if indexPath == IndexPath(row: 4, section: 0) {
          guard let image = UIImage(systemName: "bell"),let url = URL(string: "http://www.apple.com/in") else {
                return
           }
            let activityController = UIActivityViewController(activityItems: [
                image,"GDRB TECHNOLOGIES PVT LTD",
              // url
                
            ], applicationActivities: nil)
            present(activityController,animated: true)
        }
       tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
    
    
   

}
