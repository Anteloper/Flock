//
//  PostCell.swift
//  Flock
//
//  Created by Oliver Hill on 2/26/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PostCell: UICollectionViewCell {
    
    var label: UILabel?
    var postImageView: UIImageView?
    var playButtonImageView: UIImageView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func loadData(content: PostContent?){
        
        if content != nil {
            switch content!{
            case .TextPost(let text):
                clearCell()
                initializeLabel()
                label!.text = text
            case .VideoPost(let path):
                clearCell()
                initializeImageView()
                initializePlayView(isYoutube: false)
                postImageView!.image = thumbnailFromFile(path)
            case .PhotoPost(let photo):
                clearCell()
                initializeImageView()
                postImageView!.image = cropToSquare(photo)
            case .ArticlePost(let articleLink):
                clearCell()
                initializeImageView()
                postImageView!.image = photoFromArticleLink(articleLink)
            case .YoutubePost(let videoID):
                clearCell()
                initializeImageView()
                loadYoutubeThumbnail(videoID)
                initializePlayView(isYoutube: true)
                
            }
        }
    }
    

    
    func initializeLabel(){
        
        label = UILabel(frame: bounds)
        label!.textAlignment = .Center
        label!.numberOfLines = 0
        label!.font = Properties.cellFont
        contentView.addSubview(label!)
        
    }
    
    func initializeImageView(){
        
        postImageView = UIImageView(frame: bounds)
        postImageView!.contentMode = .ScaleAspectFit
        contentView.addSubview(postImageView!)
    }
    
    func initializePlayView(isYoutube isYoutube: Bool){
        
        playButtonImageView = UIImageView(frame: Properties.playButtonFrame)
        if isYoutube{
            playButtonImageView!.image = UIImage(imageLiteral: "PlayRed")
        }
        else{
            playButtonImageView!.image = UIImage(imageLiteral: "PlayBlue")
        }
        playButtonImageView!.alpha = 0.8
        contentView.addSubview(playButtonImageView!)
    }
    
    func clearCell(){
        label?.removeFromSuperview()
        postImageView?.removeFromSuperview()
        playButtonImageView?.removeFromSuperview()
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Image Handling
    func thumbnailFromFile(path: String) -> UIImage{
        
        var returnImage = UIImage()
        do {
            let asset = AVURLAsset(URL: NSURL(fileURLWithPath: path), options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            let cgImage = try imgGenerator.copyCGImageAtTime(CMTimeMake(10 , 1), actualTime: nil)
            returnImage = cropToSquare(UIImage(CGImage: cgImage))
            
        } catch {
            returnImage = blackSquare()
        }
        return returnImage
    }
    
    
    func cropToSquare(image: UIImage) -> UIImage{
        
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(self.frame.width)
        var cgheight: CGFloat = CGFloat(self.frame.height)
        
   
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    
    
    //Asynchronously updates the postImageView of the cell
    func loadYoutubeThumbnail(videoID: String){
        
        let backupImage = blackSquare()
        
        let url = NSURL(string: "https://i1.ytimg.com/vi/\(videoID)/\("mqdefault.jpg")")
        downloadImageWithUrl(url!, completionHandler: { (suceeded, dataImage) in
            if suceeded{
                self.postImageView!.image = self.cropToSquare(dataImage!)
            }
            else{
                self.postImageView!.image = backupImage
            }
        })
        
    }
    
    
    
    
    func downloadImageWithUrl(url: NSURL, completionHandler:(succeeded: Bool, image: UIImage?) -> Void) -> Void {
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error == nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if data != nil{
                        let image = UIImage(data: data!)
                        completionHandler(succeeded: true, image: image)
                    }
                    else{
                        //TODO: if image is nil
                    }
                })
            } else {
                completionHandler(succeeded: false, image: nil)
            }
        })
        task.resume()
    }
    
    
    func blackSquare() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 0)
        UIColor.blackColor().setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return returnImage
        
    }
    
    func photoFromArticleLink(articleLink: NSURL) -> UIImage{
        //TODO: 
        return blackSquare()
    }
}
