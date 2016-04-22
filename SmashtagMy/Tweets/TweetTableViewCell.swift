//
//  TweetTableViewCell.swift
//  SmashtagMy
//
//  Created by Polina Petrenko on 03.05.15.
//  Copyright (c) 2015 Polina Petrenko. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    //create public API of tweetTableViewCell
    var tweet : Tweet? {
        didSet {
            updateUI()
        }
    }

    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    // ctrate this Label by text and not connect it to the View
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        if let tweet = self.tweet
        {
            var tweetTextWithPic = tweet.text         
            for _ in tweet.media {
                tweetTextWithPic += " 📷"
            }

            let attrText = NSMutableAttributedString(string: tweetTextWithPic)
            
            // new color to hashtags, urls and names using addAttribute:
            for hashtag in tweet.hashtags {
               attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.orangeColor(), range: hashtag.nsrange!)
            }
            for url in tweet.urls {
               attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(), range: url.nsrange!)
            }
            for names in tweet.userMentions {
                attrText.addAttribute(NSForegroundColorAttributeName, value: UIColor.greenColor(), range: names.nsrange!)
            }
            
            tweetTextLabel?.attributedText = attrText

            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            if let profileImageURL = tweet.user.profileImageURL {
                if let imageData = NSData(contentsOfURL: profileImageURL) {
                    tweetProfileImageView?.image = UIImage(data: imageData)
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }
    }
    
}
