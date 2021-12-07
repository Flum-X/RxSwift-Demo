//
//  AppDelegate.swift
//  RxSwift-Demo
//
//  Created by DaXiong on 2020/5/15.
//  Copyright © 2020 DaXiong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let simpleVC = UIStoryboard(name: "SimpleValidation", bundle: nil).instantiateInitialViewController()
        window?.rootViewController = simpleVC
        window?.makeKeyAndVisible()
        
        return true
    }

}

extension AppDelegate {
    
    @objc static func shared() -> AppDelegate? {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            return delegate
        }
        return nil
    }
    
    func setRootViewCtrl(_ ctrl: UIViewController) {
        window?.rootViewController = ctrl
    }
}
