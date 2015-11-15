//
//  ViewController.swift
//  WorkTracker
//
//  Created by alex oh on 11/13/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    var userID: Int?
    
    let beaconManager = ESTBeaconManager()
    
    var deskTimer: NSTimer?
    var coffeeTimer: NSTimer?
    var pooTimer: NSTimer?
    
    var counter = 0
    
    var referenceCheckInDate: NSDate?
    
    func updateTimer() {
        
        counter++
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beaconManager.delegate = self
        
        
        if let uuid = NSUUID(UUIDString: "5A9154BB-5E7D-19E3-E957-F549E31543D8") {
            
            let region = CLBeaconRegion(proximityUUID: uuid, identifier: "beacons")
            
            beaconManager.startRangingBeaconsInRegion(region)
            
        }

        referenceCheckInDate = NSDate()
        
        RailsRequest.session().loginWithUsername("test@email.com", andPassword: "testpass")
        
    }
    
    func locationCheckIn(locationID: Int, andEmail email: String) {
        
        var info = RequestInfo()
        
        info.endpoint = "checkins"
        info.method = .POST
        info.parameters = [
            
            "location_id" : locationID,
            "email" : email
            
        ]
        
        RailsRequest.session().requestWithInfo(info) { (returnedInfo) -> () in
            
            print(returnedInfo)
            
            if let user = returnedInfo?["user"] as? [String:AnyObject] {
                
                if let timeIn = user["time_in"] as? String {
                    
                    print(timeIn)
                    
                }
                
            }
            
        }
        
    }
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        // this is to filter out any unknowns
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        guard let beacon = knownBeacons.first else { return }
                
                print(beacon.major,beacon.minor,beacon.accuracy,beacon.proximity.rawValue)
        
        
        if beacon.major == 100 {
            
            print("100")
            
            
        }
        
        if beacon.major == 200 {
            
            print("200")
            
        }
        
        if beacon.major == 300 {
            
            print("300")
            
        }
       
        
        if referenceCheckInDate != nil {
            if NSDate().timeIntervalSinceDate(referenceCheckInDate!) > 5 {
                
                // send rails data
                print("hey ya")
                
                locationCheckIn(Int(beacon.major), andEmail: "test@email.com")

                referenceCheckInDate = NSDate()
                
            }
            
        }
        
        
    }
    
    
}















