//
//  StackController.swift
//  Flock
//
//  Created by Oliver Hill on 3/4/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class StackController: UIViewController, UIGestureRecognizerDelegate {
    
    var postView: UIView?
   
    var postImageView: UIImageView?
    var textLabel: UILabel?
    var webView: UIWebView?
    
    var whoPostedLabel: UILabel?
    var whoPostedPictureVew: UIImage?
    var captionField: UILabel?
    
    var videoPlayer: AVPlayer?
    var videoController: AVPlayerViewController?
    
    var postViewInWideMode = false{didSet{wideModeChange()}}
    
    var history = [Int: Post]()
    var selected = Int()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        addSwipeRecognizer()
        addPostView()
        fillContent()
    }

    
    //MARK: Initializers
    init(withHistory stack: [Int: Post], onPost num: Int){

        super.init(nibName: nil, bundle: nil)
        history = stack
        selected = num
        let post = stack[num]
        if post != nil{
            switch post!.content{
                case .YoutubePost(_): postViewInWideMode = true
                default: postViewInWideMode = false
            }
        }
    }

    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(withHistory: [0:Post()], onPost: 0)
    }
    
    //MARK: User Response
    func didSwipe(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .Ended{
            let point = recognizer.translationInView(view)
            
            //Horizontal Swipe
            if abs(point.x) >= abs(point.y) {
           
                if point.x <= 0 {
                    if !isEndOfStack(){
                        newPostAnimation(true)
                        selected += 1
                        fillContent()
                    }
                    else{
                        newPostAnimation(true)
                    }
                }
            
                else {
                    if !isBeginningOfStack(){
                        newPostAnimation(false)
                        selected -= 1
                        fillContent()
                    }
                    else{
                        newPostAnimation(false)
                    }
                }
            }
            //Vertical Swipe
            else{
                if point.y >= 0 {
                   self.dismissViewControllerAnimated(true, completion: nil)
                }
                else{
                    print("comments")
                }
            }
        }
    }
    
    //MARK: Fill Content
    func fillContent(){
        let post = history[selected]
        if post != nil{
            switch post!.content{
            case .TextPost(let text):
                clearPostView()
                addTextLabel(withText: text)
            case .PhotoPost(let image):
                clearPostView()
                addPostImageView()
                postImageView!.image = image
            case .YoutubePost(let videoID):
                clearPostView()
                addWebView(withVideo: videoID)
            case .VideoPost(let videoPath):
                clearPostView()
                addVideoView(ofPath: videoPath)
            case .ArticlePost(let articleLink):
                clearPostView()
                addWebView(withArticle: articleLink)
            }
            
            addIdentifiers(post!)
        }
    }
    
    //MARK: Add Subviews
    func addPostView(){
        if !postViewInWideMode{
         postView = UIView(frame: Properties.postViewFrame(view.center, width: self.view.frame.size.width))
        
        }
        else{
            postView = UIView(frame: Properties.youtubeContentFrame(view.center))
        
        }
        postView!.backgroundColor = Properties.themeColor
        view.addSubview(postView!)
    }
    
    func addPostImageView(){
        
        postViewInWideMode = false
        postImageView = UIImageView(frame: Properties.postViewFrame(view.center, width: view.frame.size.width-10))
        view.addSubview(postImageView!)
        view.bringSubviewToFront(postImageView!)
    }
    
    func addTextLabel(withText text: String){
        
        postViewInWideMode = false
        textLabel = UILabel(frame: Properties.postViewFrame(view.center, width: view.frame.size.width-10))
        textLabel!.backgroundColor = UIColor.whiteColor()
        textLabel!.text = text
        textLabel!.font = UIFont(name: "Helvetica Neue Light", size: 17)
        textLabel!.numberOfLines = 0
        textLabel!.textAlignment = .Center
        view.addSubview(textLabel!)
        view.bringSubviewToFront(textLabel!)
    }
    
    //WebView for Youtube Videos
    func addWebView(withVideo videoID: String){
        postViewInWideMode = true
        webView = UIWebView(frame: Properties.youtubeContentFrame(view.center))
        webView!.backgroundColor = UIColor.blackColor()
        webView!.allowsInlineMediaPlayback = true
        webView!.mediaPlaybackRequiresUserAction = false
        webView!.opaque = false
        webView!.scrollView.scrollEnabled = false
        webView!.userInteractionEnabled = true
        view.addSubview(webView!)
        let embedhtml = Properties.embeddedHTML(videoID)
        webView!.loadHTMLString(embedhtml, baseURL: nil)
    }
    
    func addWebView(withArticle articleLink: NSURL){
        webView = UIWebView(frame: Properties.postViewFrame(view.center, width: view.frame.size.width-10))
        webView!.backgroundColor = UIColor.whiteColor()
        webView!.userInteractionEnabled = false
        webView!.mediaPlaybackRequiresUserAction = true
        view.addSubview(webView!)
        webView!.loadRequest(NSURLRequest(URL: articleLink))
    }
    
    
    func addVideoView(ofPath path: String){

        postViewInWideMode = true
        videoPlayer = AVPlayer(URL: NSURL(fileURLWithPath: path))
        videoController = AVPlayerViewController()
        videoController!.player = videoPlayer
        videoController!.view.frame = Properties.youtubeContentFrame(view.center)
        addChildViewController(videoController!)
        view.addSubview(self.videoController!.view)
        
        videoController!.didMoveToParentViewController(self)
       
    }
    
    func addSwipeRecognizer(){
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(StackController.didSwipe(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
    }
    
    
    
    func addIdentifiers(post: Post){
        if postView != nil{
            let origin = CGPoint(x: postView!.frame.origin.x, y: postView!.frame.origin.y - (Properties.identifierLabelHeight+8))
            whoPostedLabel = UILabel(frame: CGRect(origin: origin, size: CGSize(width: postView!.frame.size.width, height: Properties.identifierLabelHeight)))
            whoPostedLabel!.text = post.userPosted.firstName + ":"
            whoPostedLabel!.font = UIFont(name: "Helvetica Neue Light", size: 24)
            whoPostedLabel!.textColor = Properties.themeColor
            view.addSubview(whoPostedLabel!)
            
            if post.caption != nil{
                captionField = UILabel(frame: CGRect(x: postView!.frame.origin.x, y: postView!.frame.maxY + 5, width: postView!.frame.size.width, height: 100))
                captionField!.text = post.caption
                captionField!.textColor = Properties.themeColor
                captionField!.numberOfLines = 0
                view.addSubview(captionField!)
                
            }
        }
    }
    
    func clearPostView(){
        whoPostedLabel?.removeFromSuperview()
        whoPostedLabel = nil
        captionField?.removeFromSuperview()
        captionField = nil
        webView?.removeFromSuperview()
        webView = nil
        postImageView?.removeFromSuperview()
        postImageView = nil
        textLabel?.removeFromSuperview()
        textLabel = nil
        videoPlayer?.pause()
        videoController?.removeFromParentViewController()
        videoController?.view.removeFromSuperview()
        videoPlayer = nil
        videoController = nil
    }
    
    //MARK: Animations
    func wideModeChange(){

        if self.postViewInWideMode{
            UIView.animateWithDuration(0.2, animations: { [unowned self] in
                self.postView?.frame = Properties.postViewFrameYoutubeContent(self.view.center)
            })
        }
        else{
            UIView.animateWithDuration(0.2, animations: { [unowned self] in
                self.postView?.frame = Properties.postViewFrame(self.view.center, width: self.view.frame.size.width)
                }
            )
        }
    }
    
    
    func newPostAnimation(rotateRight: Bool){
        var rotation = M_PI_4
        if(!rotateRight){
            rotation = -rotation
        }
        dispatch_async(dispatch_get_main_queue()){
            UIView.animateWithDuration(0.1, animations: {
                self.postView!.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
                }, completion: { didComplete in
                    if(didComplete){
                        UIView.animateWithDuration(0.1, animations:  {
                            self.postView!.transform = CGAffineTransformMakeRotation(CGFloat(0))
                            }
                        )
                    }
                }
            )
        }
    }
    
    
    func isBeginningOfStack() -> Bool{
        if history[selected-1] == nil{
            return true
        }
        return false
    }
    
    func isEndOfStack() -> Bool{
        if history[selected+1] == nil{
            return true
        }
        return false
    }
}
