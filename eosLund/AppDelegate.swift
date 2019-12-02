//
//  AppDelegate.swift
//  eosLund
//
//  Created by Denis Rakitin on 2019-11-26.
//  Copyright © 2019 Denis Rakitin. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()

        return true
    }

    // MARK: UISceneSession Lifecycle
    @available (iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available (iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

//extension UIApplication {
//var statusBarUIView: UIView? {
//    if #available(iOS 13.0, *) {
//        let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//         statusBar.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
//         UIApplication.shared.keyWindow?.addSubview(statusBar)
//    } else {
//         UIApplication.shared.statusBarUIView?.backgroundColor = UIColor.init(red: 243/250, green: 243/250, blue: 243/250, alpha: 1)
//    }
//    
//    }
//}

