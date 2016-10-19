//
//  TheaterController.swift
//  Flock
//
//  Created by Oliver Hill on 3/27/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

class TheaterController: UIViewController, UIWebViewDelegate, UIGestureRecognizerDelegate {
    var post: Post?
    
    
    override func viewDidLoad(){
        view.backgroundColor = UIColor.blackColor()
        
        //Load data
        switch post!.content{
        case .ArticlePost(let articleLink):
            loadArticle(articleLink)
        case .PhotoPost(let image):
            loadPhoto(image)
        default:break
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let captionLabel = UILabel(frame: Properties.captionFrame(view.frame.size))
        captionLabel.text = post?.caption
        captionLabel.alpha = 1.0
        captionLabel.textAlignment = .Center
        captionLabel.textColor = UIColor.blackColor()
        captionLabel.numberOfLines = 0
        captionLabel.font = Properties.captionFont
        captionLabel.backgroundColor = Properties.tiltColor
        view.addSubview(captionLabel)
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(TheaterController.didSwipe(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
        
    }
    
    func loadArticle(link: NSURL){
        let webView = UIWebView(frame: Properties.contentFrame(view.frame.size))
        webView.loadRequest(NSURLRequest(URL: link))
        webView.backgroundColor = UIColor.blackColor()
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = true
        webView.opaque = false
        webView.scrollView.scrollEnabled = true
        webView.userInteractionEnabled = true
        view.addSubview(webView)
    }
    
    func loadPhoto(image: UIImage){
        
    }
    
    func didSwipe(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .Ended{
            let point = recognizer.translationInView(view)
            if abs(point.y) >= abs(point.x) && point.y <= 0{
                let cc = CommentsController()
                cc.modalTransitionStyle = .CoverVertical
                presentViewController(cc, animated: true, completion: nil)
            }
        }
    }
}
