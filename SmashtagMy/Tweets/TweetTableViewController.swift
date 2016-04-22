//
//  TweetTableViewController.swift
//  SmashtagMy
//
//  Created by Polina Petrenko on 01.05.15.
//  Copyright (c) 2015 Polina Petrenko. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController , UITextFieldDelegate {
 
    var tweets = [[Tweet]]()
   
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var searchText : String? = "#ios" {
        didSet {
            //every time search changes:
            lastSuccessfullRequest = nil
            searchTextField?.text = searchText
            tweets.removeAll()
            tableView.reloadData()
            refresh()
            if searchText != nil {
                if historyOfSearch.count > 99 {
                    historyOfSearch.removeLast()
                }
                historyOfSearch = [searchText!] + historyOfSearch
            }
        }
    }
    
    var historyOfSearch : [String] {
        //return array of strings , and if it's nil , or some junk , the empty array will be returned
        get{ return defaults.objectForKey(History.DefaultsKey) as? [String] ?? []  }
        
        set{ defaults.setObject(newValue, forKey: History.DefaultsKey) }
    }
    
    private struct History {
        static let DefaultsKey = "TweetTableViewController.History"
    }
    
     // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        refresh()
    }
    
    var lastSuccessfullRequest : TwitterRequest?
    
    //calculate next request based on the last one
    var nextRequestToAttempt : TwitterRequest? {
        if lastSuccessfullRequest == nil {
            if searchText != nil {
                return TwitterRequest(search : searchText!, count : 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfullRequest!.requestForNewer
        }
    }

    func refresh() {
        if refreshControl != nil {
            refreshControl?.beginRefreshing()
        }
        refresh(refreshControl)
    }
    
    @IBAction func refresh(sender: UIRefreshControl?) {
        if searchText != nil {
    // count is how many tweets do I want to find with this request
            if let request = nextRequestToAttempt {
    // fetchTweets gives back array of tweets
                request.fetchTweets { (newTweets) -> Void in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        if newTweets.count > 0 {
                            self.lastSuccessfullRequest = request
                            self.tweets.insert(newTweets, atIndex: 0)
                            self.tableView.reloadData()
                            sender?.endRefreshing()
                        }
                    }
                }
            }
        } else {
    // if searchText == nil
            sender?.endRefreshing()
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == searchTextField {
            textField.resignFirstResponder()
            searchText = textField.text
        }
        return true
    }
    
    // MARK: - UITableViewDataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    private struct Storyboard {
        static let cellReuseIdentifier = "Tweet"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.cellReuseIdentifier, forIndexPath: indexPath) as! TweetTableViewCell
        cell.tweet = tweets[indexPath.section][indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? UITableViewController
        
        if let destToMensions = destination as? MensionsTableViewController {
            if segue.identifier == "Mensions" {
                if let myTableCell = sender as? TweetTableViewCell {
                    destToMensions.title = "Author is \(myTableCell.tweet!.user.name)"
                    destToMensions.mensionsTweet = myTableCell.tweet
                }
            }
        }
    }
    
}
