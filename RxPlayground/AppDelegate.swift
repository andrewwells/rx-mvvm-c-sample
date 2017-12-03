//
//  AppDelegate.swift
//  RxPlayground
//
//  Created by Andrew Wells on 11/23/17.
//  Copyright © 2017 Andrew Wells. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let appCoordinator = AppCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        
        _ = appCoordinator.start()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = appCoordinator.rootViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

