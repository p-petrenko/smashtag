//
//  SearchHistoryTableViewController.swift
//  SmashtagMy
//
//  Created by Polina Petrenko on 18.05.15.
//  Copyright (c) 2015 Polina Petrenko. All rights reserved.
//

import UIKit

class SearchHistoryTableViewController: UITableViewController {
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var historyOfSearch : [String] {
        
        //return array of string type , and if it's nil , the empty array will be returned
        get{ return defaults.objectForKey(History.DefaultsKey) as? [String] ?? []  }
        
        set{ defaults.setObject(newValue, forKey: History.DefaultsKey) }
    }
    
    private struct History {
        static let DefaultsKey = "TweetTableViewController.History"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyOfSearch.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = tableView.dequeueReusableCellWithIdentifier("history cell", forIndexPath: indexPath)
        cell.textLabel?.text = historyOfSearch[indexPath.row]
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController]
        // Pass the selected object to the new view controller.
        if let tweetTVC = segue.destinationViewController as? TweetTableViewController {
            if let identifier = segue.identifier {
                if identifier == "search history results" {
                    let indexPath = tableView.indexPathForSelectedRow
                    tweetTVC.searchText = "\(historyOfSearch[indexPath!.row])"
                }
            }
        }
    }
}
