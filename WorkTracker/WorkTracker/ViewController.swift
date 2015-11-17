//
//  ViewController.swift
//  WorkTracker
//
//  Created by alex oh on 11/13/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ESTBeaconManagerDelegate {
    
    @IBOutlet weak var officeDurationLabel: UILabel!
    
    @IBOutlet weak var coffeeDurationLabel: UILabel!
    
    @IBOutlet weak var bathroomDurationLabel: UILabel!
    
    
    @IBOutlet weak var emailLabel: UILabel!
    
    var userID: Int?
    
    var email = RailsRequest.session().email
    
//    var isPooCounting = false
//    var isCoffeeCounting = false
//    var isDeskCounting = false
    
    let beaconManager = ESTBeaconManager()
    
    var timer: NSTimer?
    
//    var counter = 0
    
//    var beaconOneCount = 0
//    var beaconTwoCount = 0
//    var beaconThreeCount = 0
    
    var referenceCheckInDate: NSDate?
    
    var beaconMajor: Int?
    
    var bathroomDuration: Int?
    var officeDuration: Int?
    var breakDuration: Int?
    
//    func updateTimer() {
//        
//        
//        if beaconMajor == 100 {
//            
//            beaconOneCount++
//            
//        }
//        
//        if beaconMajor == 200 {
//            
//            beaconTwoCount++
//            
//        }
//        
//        if beaconMajor == 300 {
//            
//            beaconThreeCount++
//            
//        }
    
//        counter++
//        
//        if beacon.major = 100 {
//            beaconOneCount++
//        }
//        if beacon.major = 200 {
//            beaconOneCount++
//        }
        
//    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailLabel.text = self.email
        
        beaconManager.delegate = self
        
        
        if let uuid = NSUUID(UUIDString: "5A9154BB-5E7D-19E3-E957-F549E31543D8") {
            
            let region = CLBeaconRegion(proximityUUID: uuid, identifier: "beacons")
            
            beaconManager.startRangingBeaconsInRegion(region)
            
        }

        referenceCheckInDate = NSDate()
        
        
        
        getDaysReport("20151115")
        

        
    }
    
    func locationCheckIn(locationID: Int, andEmail email: String, andDuration duration: Int) {
        
        var info = RequestInfo()
        
        info.endpoint = "checkins"
        info.method = .POST
        info.parameters = [
            
            "location_id" : locationID,
            "email" : email,
            "duration" : duration
            
        ]
        
        RailsRequest.session().requestWithInfo(info) { (returnedInfo) -> () in
            
        }
        
    }
    
    func getDaysReport(day: String) {
        
        var info = RequestInfo()
        
        info.endpoint = "checkins/report/\(day)"
        info.method = .GET
        
        RailsRequest.session().requestWithInfo(info) { (returnedInfo) -> () in
            
            print(returnedInfo)
            
            if let array = returnedInfo as? [[String:AnyObject]] {
                
                for dictionary in array {
                    
                    if dictionary["email"] as? String == self.email && dictionary["location"] as? String == "Bathroom" {
                        
                        self.bathroomDuration = dictionary["duration"] as? Int
                        print(self.bathroomDuration)
                        
                        if self.bathroomDuration != nil {
                            
                            if Int(self.bathroomDuration! % 60) < 10 {
                                
                                let number = "\(Int(self.bathroomDuration! / 60)):0\(Int(self.bathroomDuration! % 60))"
                                
                                self.bathroomDurationLabel.text = String(number)
                                
                            }
                            
                            if Int(self.bathroomDuration! % 60) >= 10 {
                                
                                let number = "\(Int(self.bathroomDuration! / 60)):\(Int(self.bathroomDuration! % 60))"
                                
                                self.bathroomDurationLabel.text = String(number)
                                
                            }
                            
                        }
                    }
                    
                    if dictionary["email"] as? String == self.email && dictionary["location"] as? String == "Office" {
                        
                        self.officeDuration = dictionary["duration"] as? Int
                        print(self.officeDuration)
                        
                        if self.officeDuration != nil {
                            
                            if Int(self.officeDuration! % 60) < 10 {
                                
                                let number = "\(Int(self.officeDuration! / 60)):0\(Int(self.officeDuration! % 60))"
                                
                                self.officeDurationLabel.text = String(number)
                                
                            }
                            
                            if Int(self.officeDuration! % 60) >= 10 {
                                
                                let number = "\(Int(self.officeDuration! / 60)):\(Int(self.officeDuration! % 60))"
                                
                                self.officeDurationLabel.text = String(number)
                                
                            }
                            
                            
                        }
                        
                    }
                    
                    if dictionary["email"] as? String == self.email && dictionary["location"] as? String == "Break Room" {
                        
                        self.breakDuration = dictionary["duration"] as? Int
                        print(self.breakDuration)
                        
                        if self.breakDuration != nil {
                            
                            
                            if Int(self.breakDuration! % 60) < 10 {
                                
                                let number = "\(Int(self.breakDuration! / 60)):0\(Int(self.breakDuration! % 60))"
                                
                                self.coffeeDurationLabel.text = String(number)
                                
                            }
                            
                            if Int(self.breakDuration! % 60) >= 10 {
                                
                                let number = "\(Int(self.breakDuration! / 60)):\(Int(self.breakDuration! % 60))"
                                
                                self.coffeeDurationLabel.text = String(number)
                                
                            }
                            
                        }
                    }
                    
                }
                
                
                
            }
            
        }
        
    }

    
    
    
    
    
    
    
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        
        // this is to filter out any unknowns
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        
        guard let beacon = knownBeacons.first else { return }
                        
        beaconMajor = beacon.major as Int
        
        
        if referenceCheckInDate != nil {
            if NSDate().timeIntervalSinceDate(referenceCheckInDate!) >= 5 {
                
                let timeInterval = Int(NSDate().timeIntervalSinceDate(referenceCheckInDate!))
                
                if beaconMajor == 100 {
                    
                    if self.email != nil {
                    locationCheckIn(Int(beacon.major), andEmail: self.email!, andDuration: timeInterval)
                    }
                }
                
                if beaconMajor == 200 {
                    
                    if self.email != nil {
                    locationCheckIn(Int(beacon.major), andEmail: self.email!, andDuration: timeInterval)
                    }

                }
                
                if beaconMajor == 300 {
                    
                    if self.email != nil {
                    locationCheckIn(Int(beacon.major), andEmail: self.email!, andDuration: timeInterval)
                    }

                }
        
                referenceCheckInDate = NSDate()
                
            }
            
        }
        
        
    }
    
    
}






