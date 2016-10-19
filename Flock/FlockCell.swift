//
//  FlockCell.swift
//  Flock
//
//  Created by Oliver Hill on 3/11/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

class FlockCell: UITableViewCell {
    
    
    
    //This function does everything except handle gestures
    func loadData(groupName: String, groupPicture: UIImage, firstMembers:[UIImage], newPosts: Bool){
        loadGroupPhoto(groupPicture)
        loadMemberPhotos(groupName, firstMembers: firstMembers, newPosts: newPosts)
    }

    
    func loadGroupPhoto(photo: UIImage){
        let photoView = UIImageView(frame: CGRect(x: Properties.flockCellHeight/10,
            y: Properties.flockCellHeight/10, width: Properties.flockCellHeight*4/5 ,
            height: Properties.flockCellHeight*4/5))
        photoView.image = photo
        photoView.layer.cornerRadius = photoView.frame.width/2
        photoView.clipsToBounds = true
        contentView.addSubview(photoView)
    }
    
    func loadMemberPhotos(groupName: String, firstMembers: [UIImage], newPosts: Bool){
     
        let groupLabel = UILabel(frame: CGRect(x: Properties.flockCellHeight+5,
            y: Properties.flockCellHeight/10,
            width: contentView.frame.width-(Properties.flockCellHeight*4/5),
            height: Properties.flockCellHeight/4))
        groupLabel.text = groupName
        groupLabel.numberOfLines = 0
        contentView.addSubview(groupLabel)
        
        var count = 0
        for photo in firstMembers{
            let frame = UIImageView(frame: CGRect(x: groupLabel.frame.origin.x + CGFloat(55*count),
                y: groupLabel.frame.maxY+8, width: 50, height: 50))

            frame.image = photo
            frame.layer.cornerRadius = frame.frame.width/2
            frame.clipsToBounds = true
            contentView.addSubview(frame)
            count+=1
        }
        
        if newPosts{
            let length: CGFloat = Properties.flockCellHeight/8
            let newPostsView = UIView(frame: CGRect(x: contentView.frame.width,
                y: length, width: length, height: length))
            newPostsView.layer.cornerRadius = newPostsView.frame.width/2
            newPostsView.backgroundColor = Properties.tiltColor
            newPostsView.alpha = 0.5
            contentView.addSubview(newPostsView)
        }
        
    }
    
    func clearData(){
        for subview in contentView.subviews{
            subview.removeFromSuperview()
        }
    }
    
}
