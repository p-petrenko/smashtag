//
//  ImageViewController.swift
//  SmashtagMy
//
//  Created by Polina Petrenko on 15.05.15.
//  Copyright (c) 2015 Polina Petrenko. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate
{
    var imageURL : NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            let imageData = NSData(contentsOfURL: url)
            if imageData != nil {
                image = UIImage(data: imageData!)
            } else {
                image = nil
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 3.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    private var imageView = UIImageView()
    
    private var image : UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()

            scrollView?.contentSize = imageView.frame.size
            if newValue != nil {
                let ratioWidth = view.frame.size.width / imageView.image!.size.width
                let ratioHeight = view.frame.size.height / imageView.image!.size.height
                
                if (ratioWidth >= ratioHeight) {
                    scrollView?.zoomScale = ratioWidth
                }
                else if (ratioHeight > ratioWidth) {
                    scrollView?.zoomScale = ratioHeight
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        if image == nil {
            fetchImage()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
}
