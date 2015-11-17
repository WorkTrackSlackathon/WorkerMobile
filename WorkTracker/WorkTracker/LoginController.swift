//
//  LoginController.swift
//  WorkTracker
//
//  Created by alex oh on 11/15/15.
//  Copyright © 2015 Alex Oh. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak var emailLoginField: UITextField!

    @IBOutlet weak var passwordLoginField: UITextField!
    
    
    @IBAction func loginButton(sender: AnyObject) {
        
        guard let email = emailLoginField.text else { return }
        guard let  password = passwordLoginField.text else { return }
        
        RailsRequest.session().loginWithUsername(email, andPassword: password, success: { didLogin in
            
            if didLogin {
                
                let WKstoryboard = UIStoryboard(name: "wkrStoryboard", bundle: nil)
                
                let VC = WKstoryboard.instantiateViewControllerWithIdentifier("VC")
                
                self.presentViewController(VC, animated: true, completion: nil)
                
                
            } else {
                
                // throw an alert error that login failed
                
            }
            
        })

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    
    
    }

}
