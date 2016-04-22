//
//  MensionsTableViewController.swift
//  SmashtagMy
//
//  Created by Polina Petrenko on 07.05.15.
//  Copyright (c) 2015 Polina Petrenko. All rights reserved.
//

import UIKit

class MensionsTableViewController: UITableViewController {

    var mensionsTweet : Tweet?

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return 1 // "Images"
        case 1 : return mensionsTweet!.urls.count
        case 2 : return mensionsTweet!.hashtags.count
        case 3 : return mensionsTweet!.userMentions.count
        default : return 0 // "Default case"
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 :
            if mensionsTweet!.media.count != 0 {
                return "Images"
            }else {
                return ""
            }
        case 1 :
            if mensionsTweet!.urls.count != 0 {
                return "URLs"
            } else {
                return ""
            }
        case 2 :
            if mensionsTweet!.hashtags.count != 0 {
               return "Hashtags"
            } else {
                return ""
            }
        case 3 :
            if mensionsTweet!.userMentions.count != 0 {
                return "Users"
            } else {
                return ""
            }
        default : return "Default case"
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        switch indexPath.section {
        case 0 :
            if mensionsTweet!.media.count > 0 {
                if mensionsTweet!.media[indexPath.row].url != nil {
                    if let myCell = tableView.dequeueReusableCellWithIdentifier("Images", forIndexPath: indexPath) as? ImageInMensionsTableViewCell {
                        myCell.imagesInTweet.image = UIImage(data: NSData(contentsOfURL: mensionsTweet!.media[indexPath.row].url)!)
                        cell = myCell
                    }
                }
            }
        case 1 :
            cell = tableView.dequeueReusableCellWithIdentifier("Text mensions", forIndexPath: indexPath) as! MensionTableViewCell
            cell.textLabel?.text = "URL : " + mensionsTweet!.urls[indexPath.row].keyword
        case 2 :
            cell = tableView.dequeueReusableCellWithIdentifier("Text mensions", forIndexPath: indexPath) as! MensionTableViewCell
            cell.textLabel?.text = "Hashtag : " + mensionsTweet!.hashtags[indexPath.row].keyword
            
        case 3 :
            cell = tableView.dequeueReusableCellWithIdentifier("Text mensions", forIndexPath: indexPath) as! MensionTableViewCell
            cell.textLabel?.text = "User : " + mensionsTweet!.userMentions[indexPath.row].keyword
        default :
            cell = tableView.dequeueReusableCellWithIdentifier("Text mensions", forIndexPath: indexPath) as! MensionTableViewCell
            cell.textLabel?.text = "Default case"
        }
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0 :
            if mensionsTweet!.media.count != 0 {
                return CGFloat(tableView.bounds.width / CGFloat(mensionsTweet!.media[indexPath.row].aspectRatio))
            }else {
                return 0
            }
        default :
            return UITableViewAutomaticDimension
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1 : UIApplication.sharedApplication().openURL(NSURL(string: mensionsTweet!.urls[indexPath.row].keyword)!)
        case 2 : performSegueWithIdentifier("goBack", sender: nil)
        case 3 : performSegueWithIdentifier("goBack", sender: nil)
        default : break
        }
        
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if let ivc = segue.destinationViewController as? ImageViewController {
            if let identifier = segue.identifier {
                if identifier == "BigImage" {
                    let indexPath = tableView.indexPathForSelectedRow
                    ivc.imageURL = mensionsTweet!.media[indexPath!.row].url
                }
                else {
                    ivc.imageURL = nil
                }
            }
        }
            // tvc23 = TVC which appears after touching 2-nd or 3-d cell in mensions
        else if let tvc23 = segue.destinationViewController as? TweetTableViewController {
            if let identifier = segue.identifier {
                if identifier == "goBack" {
                    let indexPath = tableView.indexPathForSelectedRow
                    
                    switch indexPath!.section {
                    case 2 : tvc23.searchText = "\(mensionsTweet!.hashtags[indexPath!.row].keyword)"
                    case 3 : tvc23.searchText = "\(mensionsTweet!.userMentions[indexPath!.row].keyword)"
                    default : break
                    }
                }
            }
        }
    }

}
