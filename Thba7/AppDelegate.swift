//
//  AppDelegate.swift
//  Thba7
//
//  Created by Mohsen Qaysi on 7/30/17.
//  Copyright © 2017 Mohsen Qaysi. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var Unifomica_Sid = "sejrLD_Wnr6HwJPHNbYVS29XvPO1gu" // Get it from the Nnifonic Website
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Connect to firebase Database
        UINavigationBar.appearance().barTintColor = UIColor(red:0.09, green:0.56, blue:0.99, alpha:1.0)
        FirebaseApp.configure()
        // Services Key
        GMSServices.provideAPIKey("AIzaSyDEbT85P2Fu1WeVRRkYpj3yX5-nmNu6lgM")
        // Places Key
        GMSPlacesClient.provideAPIKey("AIzaSyD1alfLEREzjLBq8AyWPURxqvQ1bv_2TCo")        
        return true
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
        do {
            try FileManager.default.removeItem(atPath: String().filePath)
            debugPrint("Data are deleted from the filePath: \(String().filePath)")
        } catch {
            debugPrint("Something Wrong when trying to deletec the Object at filePath: \(String().filePath)")
        }
    }
    
}
