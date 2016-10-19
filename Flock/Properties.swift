//
//  Properties.swift
//  Flock
//
//  Created by Oliver Hill on 2/23/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import Foundation
import UIKit

internal struct Properties{
    
    //MARK: Navigation Item Properties
    static let barButtonFrame = CGRect(x: 0, y: 0, width: 40, height: 40)
    
   
    
    
    //MARK: GridController Properties
    
    //GridView
    static let gridViewTopMargin: CGFloat = 25
    static let gridInsets = UIEdgeInsets(top: 50, left: 20.0, bottom: 50.0, right: 20.0)
    static let gridCellSize = CGSize(width: 100, height: 100)
    
    //PeopleView
    
    //Frame of the non-scrollable group photo next to the collectionveiw
    static let groupPhotoFrame = CGRect(origin: CGPoint(x:10 ,y: 12.5), size: Properties.peopleCellSize)
       
    //Returns the frame of the collection view containting all members of the group. Based on groupPhotoFrame
    static func peopleViewFrame(width: CGFloat) -> CGRect{
        return  CGRect(x: Properties.headerHeight, y: 0, width: width-Properties.headerHeight, height: Properties.headerHeight)
    }
    
    static let peopleInsets = UIEdgeInsets(top: Properties.gridViewTopMargin, left: 10, bottom: 20, right: 10)
    static let peopleCellSize = CGSize(width: 80, height: 80)

   
    //The origin of the CGRect that defines the peopleView UICollectionView
    static let peopleCollectionOrigin = CGPoint(x: groupPhotoFrame.height+50, y: 0)
    
    
    //MARK:PostCell Properties
    
    //Change this alone to modify ratio
    static let playButtonCellRatio: CGFloat = 1/4
    
    static let themeColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
    static let tiltColor = UIColor(red: 19/255.0,green: 157/255.0, blue: 234/255.0, alpha: 1.0)
    static let cellFont = UIFont(name: "Gill Sans", size: 14)
    static let headerHeight: CGFloat = 100
    static let playButtonFrame = CGRect(origin: CGPoint(x: Properties.gridCellSize.width *
        (3 * Properties.playButtonCellRatio), y: 0),
        size: CGSize(width: Properties.gridCellSize.width * Properties.playButtonCellRatio,
        height: Properties.gridCellSize.height * Properties.playButtonCellRatio))

    

    
    //MARK: StackView Properties
    
    //size of the postView compated to the screen width
    private static let postViewRatio: CGFloat = 4/5
    
    //Change this alone to modify postView border and the actual youtubeView content
    private static let youtubeContentSize = CGSize(width: 300, height: 200)
    
    private static let articleContentSize = CGSize(width: 200, height: 400)
    
    //label containing the name of the poster
    static let identifierLabelHeight: CGFloat = 40
    
    static func embeddedHTML(videoID: String) -> String{
        return  "<html><body style='margin:0px;padding:0px;'><script type='text/javascript' src='http://www.youtube.com/iframe_api'></script><script type='text/javascript'>function onYouTubeIframeAPIReady(){ytplayer=new YT.Player('playerId',{events:{onReady:onPlayerReady}})}function onPlayerReady(a){a.target.playVideo();}</script><iframe id='playerId' type='text/html' width='\(Properties.youtubeContentSize.width)' height='\(Properties.youtubeContentSize.height)' src='http://www.youtube.com/embed/\(videoID)?enablejsapi=1&rel=0&playsinline=1&autoplay=1' frameborder='0'></body></html>"
    }
    
    static func postViewFrame(center: CGPoint, width: CGFloat) -> CGRect{
        let sideLength = Properties.postViewRatio * width
        return CGRect(x: center.x-sideLength/2, y: center.y-sideLength/2, width: sideLength, height: sideLength)
    }
    
    static func youtubeContentFrame(center: CGPoint) ->CGRect{
        return CGRect(x: center.x-Properties.youtubeContentSize.width/2,
            y: center.y-Properties.youtubeContentSize.height/2,
            width: Properties.youtubeContentSize.width,
            height: Properties.youtubeContentSize.height)
    }
    
    static func postViewFrameYoutubeContent(center: CGPoint)->CGRect{
        return CGRect(x: center.x-(Properties.youtubeContentSize.width/2+10),
            y: center.y-(Properties.youtubeContentSize.height/2+10),
            width: Properties.youtubeContentSize.width+20,
            height: Properties.youtubeContentSize.height+20)
    }
    
    
    static func articleContentFrame(center: CGPoint)->CGRect{
        
        return CGRect(origin: CGPoint(x: center.x - articleContentSize.width/2, y: center.y - articleContentSize.height/2), size: articleContentSize)
        
    }
    
    
    
    
    //MARK: GroupController Properties
    
    static let flockCellHeight: CGFloat = 100
    
    
    //MARK: NewPostController Properties
    
    static let postCategoryFont = UIFont(name: "Gill Sans", size: 16)
    
    static let captionPostingFont = UIFont(name: "Gill Sans", size: 32)
    static let textPostingFont = UIFont(name: "Gill Sans", size: 36)
    static func textFieldFrame(size size: CGSize) -> CGRect{
        return CGRect(x: size.width/10, y: 100, width: size.width*4/5, height: size.height/2)
    }
    
    //This is based on linkCaptionFieldFrame, not the other way around
    static func linkFieldFrame(size size: CGSize)->CGRect{
        return CGRect(x: size.width/10, y: 100, width: size.width*4/5, height: 50)
    }
    
    static func linkCaptionFieldFrame(size size: CGSize) ->CGRect{
        return CGRect(x: size.width/10, y: 175, width: size.width*4/5, height: size.height/3)
    }
  
    static func allFlocksSwitchFrame(size size: CGSize)->CGRect{
        let labelFrame = allFlocksLabel(size: size)
        //Switches are a fixed size so width and height don't matter
        return CGRect(x: labelFrame.maxX , y: labelFrame.origin.y, width: 0, height:0)
    }
    
    static func allFlocksLabel(size size: CGSize) ->CGRect{
        let textFrame = textFieldFrame(size: size)
        return CGRect(x: textFrame.origin.x+2, y: textFrame.maxY + 32, width: textFrame.size.width/2, height: 30)
    }
    
    static func uploadPhotoFrame(size size: CGSize) -> CGRect{
        return CGRect(x: size.width*5/24, y: 75, width: size.width/12, height: size.width/12)
    }
    
    static func capturePhotoFrame(size size: CGSize) ->CGRect{
        return CGRect(x: size.width*17/24, y: 75, width: size.width/12, height: size.width/12)
    }
    
    static func uploadLabelFrame(size size: CGSize) -> CGRect{
        let uploadFrame = uploadPhotoFrame(size: size)
        return CGRect(x: uploadFrame.midX-50, y: uploadFrame.maxY+7, width: 100, height: 20)
    }
    
    static func captureLabelFrame(size size: CGSize)->CGRect{
        let captureFrame = capturePhotoFrame(size: size)
        return CGRect(x: captureFrame.midX-50, y: captureFrame.maxY+7, width: 100, height: 20)
    }
    
    static let allFlocksLabelFont = UIFont(name: "Gill Sans", size: 18)
    
    
    //MARK:TheaterController
    static let captionBarHeight: CGFloat = 75
    static let captionFont = UIFont(name: "Gill Sans", size: 18)
    static func contentFrame(size: CGSize)->CGRect{
       return CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width, height: size.height-(captionBarHeight+64)))
    }
    static func captionFrame(size: CGSize)->CGRect{
        return CGRect(x: 0, y: size.height-captionBarHeight, width: size.width, height: captionBarHeight)
    }
    
    //MARK: Identifiers
    static let gridReuseIdentifier = "PostCell"
    static let peopleReuseIdentifier = "PersonPictureCell"
    static let groupReuseIdentifier = "FlockCell"
    static let stackControllerID = "StackView"
    static let postSelectedSegue = "PostSelected"

}
