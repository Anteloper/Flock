//
//  AppDelegate.swift
//  Flock
//
//  Created by Oliver Hill on 2/22/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let navController = UINavigationController(rootViewController: GroupController())
        navController.navigationBar.translucent = false
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.rootViewController = navController
        window!.makeKeyAndVisible()
        return true
    }
}

