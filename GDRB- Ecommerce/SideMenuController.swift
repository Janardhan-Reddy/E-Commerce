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
        super.viewDidLoad()

        // Background color
        tableView.backgroundColor = WhiteColor

        // --- Top Profile Section ---
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 100))

        // Name label
        let nameLabel = UILabel()
        nameLabel.text = "B Sai Kumar"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Email label
        let emailLabel = UILabel()
        emailLabel.text = "bandarisaikumar11225@gmail.com"
        emailLabel.font = UIFont.systemFont(ofSize: 14)
        emailLabel.textColor = .darkGray
        emailLabel.numberOfLines = 0
        emailLabel.translatesAutoresizingMaskIntoConstraints = false

        // Profile image
        let profileImageView = UIImageView(image: UIImage(named: "userAvathar"))
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true

        // Stack for labels
        let textStack = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(textStack)
        containerView.addSubview(profileImageView)
        tableView.tableHeaderView = containerView

        // Constraints
        NSLayoutConstraint.activate([
            profileImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalToConstant: 60),

            textStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: profileImageView.leadingAnchor, constant: -16),
            textStack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])

        // Table cell reuse
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
            UserDefaults.standard.removeObject(forKey: "authToken")
               UserDefaults.standard.set(false, forKey: "isLogin")

               // Load Login screen from storyboard
               let storyboard = UIStoryboard(name: "Main", bundle: nil)
               let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginController")

               // Set login screen as the rootViewController, removing TabBarController
               if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate,
                  let window = sceneDelegate.window {
                   
                   let nav = UINavigationController(rootViewController: loginVC)
                   window.rootViewController = nav
                   window.makeKeyAndVisible()
                   
                   // Optional: animation
                   UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
               }

       }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

