//
//  LoginViewController.swift
//  Twitter
//
//  Created by Sunny Yu on 9/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //once the page shows up, the action will be taken
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "userLoggedIn") == true {
            self.performSegue(withIdentifier: "loginToHome", sender: self)
        }
    }
    @IBAction func onLoginButton(_ sender: Any) {
        let myUrl = "https://api.twitter.com/oauth/request_token"
        
        //Segue - transition
        TwitterAPICaller.client?.login(url: myUrl, success: {
            //memory: remember the user
            //forkey: name of the value
            UserDefaults.standard.set(true, forKey: "userLoggedIn")
            //performing the transition
            self.performSegue(withIdentifier: "loginToHome", sender: self)
            
        }, failure: { Error
            in
            print("could not log in!")
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
