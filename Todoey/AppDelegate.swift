//
//  AppDelegate.swift
//  Todoey
//
//  Created by KAVIRAJ PANDEY on 07/07/19.
//  Copyright © 2019 KAVIRAJ PANDEY. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //MARK- Locate Realm database
        //print(Realm.Configuration.defaultConfiguration.fileURL)
  
        //Create a brand new realm object and initialise
        do {
            _ = try Realm()
        }
        catch {
            print("Error initialising Realm object \(error)")
        }
        
        return true
    }
}
