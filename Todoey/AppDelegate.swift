//
//  AppDelegate.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 07/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //this methods triggered before view did load
        print("didFinishLaunchingWithOptions")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
       //this methods calls when something happens to phone while the app is open
       // for example user receives a call, so here by code we can prevent user lose data
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        //this method triggers when you press home button or when app disappears
       print("applicationDidEnterBackground")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        //when you quit an app it still holds some resources, later it being terminated by operating system
        print("app terminated successfully")
    }


}

