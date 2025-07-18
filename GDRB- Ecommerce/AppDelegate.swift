//
//  AppDelegate.swift
//  GDRB- Ecommerce
//
//  Created by Srinivasulu Arigela on 10/11/22.
//

import UIKit
import Razorpay
import IQKeyboardManager
@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
        IQKeyboardManager.shared().isEnabled = true
        
        for family in UIFont.familyNames.sorted() {
                   print("▶︎ Family: \(family)")
                   let names = UIFont.fontNames(forFamilyName: family)
                   for name in names {
                       print("   - \(name)")
                   }
               }
        
        if let customFont = UIFont(name: "AmazonEmber-Regular", size: 18) {
                    print("✅ Custom font loaded successfully: \(customFont.fontName)")
                } else {
                    print("❌ Custom font failed to load")
                }

        return true
    }
    


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
       
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

