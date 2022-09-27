//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Sunny Yu on 9/26/22.
//  Copyright © 2022 Dan. All rights reserved.
//

import UIKit
class HomeTableViewController: UITableViewController {
    //var - can be changed
    //let - cannot be changed
    var tweetArray = [NSDictionary]() //empty dict
    var numOfTweet: Int!
    let myRefreshControl = UIRefreshControl()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.1002852395, green: 0.6974458098, blue: 0.9604418874, alpha: 1 )
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1002852395, green: 0.6974458098, blue: 0.9604418874, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1002852395, green: 0.6974458098, blue: 0.9604418874, alpha: 1)
        
        loadTweets()
        
        //action: what do you want to do to -> run loadTweet again
        myRefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    @objc func loadTweets() {
        numOfTweet = 20
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count": numOfTweet]
        //call api
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets:[NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            //end refreshing
            self.myRefreshControl.endRefreshing()
        }, failure: { Error in
            print("could not retreive tweets")
        })
    }
    
    //infinite scroll
    func loadMoreTweets() {
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numOfTweet = numOfTweet + 20
        let myParams = ["count": numOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets:[NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
        
        }, failure: { Error in
            print("could not retreive tweets")
        })
        
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweets()
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        if var textAttributes = navigationController?.navigationBar.titleTextAttributes{
//            textAttributes[NSAttributedString.Key.foregroundColor] = UIColor.white
//            navigationController?.navigationBar.titleTextAttributes = textAttributes
//        }
//        navigationController?.navigationBar.barTintColor = uicolorFromHex(#00acee)
//        navigationController?.navigationBar.tintColor = uicolorFromHex(#00acee)
//    }
//
    
   
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
        
        
        cell.userNameLabel.text = user["name"] as? String
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.rowHeight = 120
        return tweetArray.count
    }

        
}
