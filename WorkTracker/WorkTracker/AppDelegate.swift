//
//  AppDelegate.swift
//  WorkTracker
//
//  Created by alex oh on 11/13/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ESTBeaconManagerDelegate {

    var window: UIWindow?
    
    var referenceCheckInDate: NSDate?
    
    let ESTmanager = ESTBeaconManager()
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //Set delegate
        ESTmanager.requestAlwaysAuthorization()

        ESTmanager.delegate = self
        
        if let uuid = NSUUID(UUIDString: "5A9154BB-5E7D-19E3-E957-F549E31543D8") {

            let monitorRegion100 = CLBeaconRegion(proximityUUID: uuid, major: 100, identifier: "beacons100")
            let monitorRegion200 = CLBeaconRegion(proximityUUID: uuid, major: 200, identifier: "beacons200")
            let monitorRegion300 = CLBeaconRegion(proximityUUID: uuid, major: 300, identifier: "beacons300")
            
//            
//            region.notifyOnEntry = true
//            region.notifyOnExit = true
//            region.notifyEntryStateOnDisplay = true

            
            ESTmanager.startMonitoringForRegion(monitorRegion100)
            ESTmanager.startMonitoringForRegion(monitorRegion200)
            ESTmanager.startMonitoringForRegion(monitorRegion300)
            
            
        }
        
        return true

    }
    
    //func to send timer stuff to rails
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Beacon Manager


    func beaconManager(manager: AnyObject, didStartMonitoringForRegion region: CLBeaconRegion) {
        
        
    }
    
    func beaconManager(manager: AnyObject, didEnterRegion region: CLBeaconRegion) {
        
    
    }

}

