//
//  AppDelegate.swift
//  MyTencentMap
//
//  Created by sqluo on 2016/11/1.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

let SCREENSIZE = UIScreen.main.bounds.size


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,QAppKeyCheckDelegate{

    var window: UIWindow?

    var keyCheck: QAppKeyCheck?
    
    let key = "2UQBZ-PHGRF-PWKJY-J653Y-TRGXF-CLBR5"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        
        self.keyCheck = QAppKeyCheck()
        self.keyCheck?.start(self.key, with: self)
        
        QMSSearchServices.shared().apiKey = key
        
        
        let rootVC = RootViewController()
        
        let nvc = UINavigationController(rootViewController: rootVC)
        
        self.window?.rootViewController = nvc
   
        return true
    }
    
    func notifyAppKeyCheckResult(_ errCode: QErrorCode) {
        if errCode == QErrorNone {
            print("验证成功")
        }else{
            print("验证失败")
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

