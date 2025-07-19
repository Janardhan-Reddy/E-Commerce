//
//  Settings.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 09/12/22.
//

import UIKit
class Settings:UIViewController,UITableViewDelegate,UITableViewDataSource{
    var storedEmail :String = ""
    //UITableView
    @IBOutlet weak var SettingTableView: UITableView!
   
   // settingUILabel
    let settingLabel:[String] = ["Change Password","Change Email", "About Us","Delete Acount"]
    let settingImage: [UIImage] = [UIImage(named: "password1")!,
                                    UIImage(named: "email")!,
                                    UIImage(named: "about")!,
                                    UIImage(named: "delete")!,
                                   ]
    
                                 //tableView delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingImage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell",for: indexPath) as! SettingsTableViewCell
        cell.settingLabel.text = settingLabel[indexPath.row]
        cell.settingImage.image = settingImage[indexPath.row]
        
         return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    func showChangePasswordAlert() {
        let alertController = UIAlertController(title: "Change password", message: nil, preferredStyle: .alert)
        alertController.addTextField { nameTextField in
            nameTextField.placeholder = "Enter new password"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            // handle the "OK" action by calling the API with the entered text
            
            if let textField = alertController.textFields?.first, let text = textField.text {
            
                if text.isEmpty{
                    let errorAlert = UIAlertController(title: "Error", message: " textField should not be empty", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self?.present(errorAlert, animated: true, completion: nil)
                    
                } else{
                    UserDefaults.standard.set(false, forKey: "isLogin")
                    UserDefaults.standard.removeObject(forKey: "userEmail")
                    let LoginController = (self?.storyboard!.instantiateViewController(identifier: "LoginController"))! as LoginController
                    self?.navigationController?.pushViewController(LoginController, animated: true)
                    
                }
                
                
            }
        }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            // present the alert controller
            present(alertController, animated: true, completion: nil)
       }

       func showChangeEmailAlert() {
           let alertController = UIAlertController(title: "Change Email", message: nil, preferredStyle: .alert)
           alertController.addTextField { nameTextField in
               nameTextField.placeholder = "Enter new email"
           }
           
           let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
               // handle the "OK" action by calling the API with the entered text
               
               if let textField = alertController.textFields?.first, let text = textField.text {
               
                   if text.isEmpty{
                       let errorAlert = UIAlertController(title: "Error", message: "textField should not be empty", preferredStyle: .alert)
                       errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                       self?.present(errorAlert, animated: true, completion: nil)
                       
                   }
                   
                   else{
                    
                       UserDefaults.standard.set(false, forKey: "isLogin")
                       UserDefaults.standard.removeObject(forKey: "userEmail")
                       let LoginController = (self?.storyboard!.instantiateViewController(identifier: "LoginController"))! as LoginController
                       self?.navigationController?.pushViewController(LoginController, animated: true)
                       
                   }
                   
                   
               }
           }
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
               alertController.addAction(okAction)
               alertController.addAction(cancelAction)
               
               // present the alert controller
               present(alertController, animated: true, completion: nil)
       }
    func navigateToNextViewController() {
            // Instantiate and present the NextViewController
          
        }

        func navigateToAnotherViewController() {
            // Instantiate and present the AnotherViewController
         
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)

           switch indexPath.row {
           case 0:
               showChangePasswordAlert()
           case 1:
               showChangeEmailAlert()
           case 2:
               navigateToNextViewController()
            case 3:
               navigateToAnotherViewController()
           default:
               // Handle other rows if needed
               break
           }
       }
    
    override func viewDidLoad() {
        storedEmail = UserDefaults.standard.string(forKey: "userEmail")!
        self.title = "Settings"
        
    }
}
