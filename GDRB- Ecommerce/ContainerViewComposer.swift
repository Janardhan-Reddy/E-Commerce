//
//  ContainerViewComposer.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 14/12/22.
//

import UIKit

final class ContainerViewComposer {
    static func makeContainer() -> HomeViewController {
        let homeViewController = HomeViewControllerr()
        let settingsViewController = SettingsViewController()
        let aboutViewController = AboutViewController()
        let myAccountViewController = MyAccountViewController()
        let sideMenuItems = [
            SideMenuItem(icon: UIImage(systemName: "house.fill"),
                         name: "Home",
                         viewController: .embed(HomeViewControllerr())),
            SideMenuItem(icon: UIImage(systemName: "gear"),
                         name: "Settings",
                         viewController: .embed(settingsViewController)),
            SideMenuItem(icon: UIImage(systemName: "info.circle"),
                         name: "About",
                         viewController: .push(aboutViewController)),
            SideMenuItem(icon: UIImage(systemName: "person"),
                         name: "My Account",
                         viewController: .modal(myAccountViewController))
        ]
        let HomeViewController = HomeViewController(sideMenuItems: sideMenuItems)
        let container = HomeViewController

        return container
    }
}
