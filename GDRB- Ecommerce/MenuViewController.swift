//
//  MenuViewController.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 14/12/22.
//

import UIKit
protocol MenuViewControllerDelegate:AnyObject{
    func didSelect(menuitem:MenuViewController.MenOptions)
}

class MenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    weak var delegate:MenuViewControllerDelegate?
    enum MenOptions: String, CaseIterable {
    case home = "Home"
    case info = "Information"
    case appRating = "App Rating"
    case shareApp = "Share App"
    case settings = "Settings"
        case delete = "Delete account"
        
        var imageName:String{
            switch self{
            case.home:
                return "house"
            case .info:
                return "airplane"
            case .appRating:
                return "star"
            case .shareApp:
                return "message"
            case .settings:
                return "gear"
            case .delete:
                return "trash"
            }
        }
    }
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.backgroundColor = nil
        return table
    }()
    let greyColor = UIColor (red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)

    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
      
        view.backgroundColor = greyColor
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews()
        //view.safeAreaInsets.top
        tableView.frame = CGRect(x: 0, y:150 , width: view.bounds.size.width, height:
                                    view.bounds.size.height)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return MenOptions.allCases.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = MenOptions.allCases [indexPath.row].rawValue
        cell.backgroundColor = greyColor
        cell.textLabel?.textColor = .white
        cell.imageView?.image = UIImage(systemName: MenOptions.allCases[indexPath.row].imageName)
        cell.imageView?.tintColor = .white
        cell.contentView.backgroundColor = greyColor
    return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenOptions.allCases[indexPath.row]
        delegate?.didSelect(menuitem: item)
        
        
        
    }
   
       
    }
    
