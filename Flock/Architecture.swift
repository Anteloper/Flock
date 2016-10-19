//
//  PostType.swift
//  Flock
//
//  Created by Oliver Hill on 2/26/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import Foundation
import UIKit

class Group{
    
    var name = String()
    var photo = UIImage()
    var userIndex = [Int: User]()
    var postIndex = [Int: Post]()
    
    /*init(groupName: String, groupPhoto: UIImage, userDictionary: [Int: User], postDictionary: [Int: Post]){
        name = groupName
        photo = groupPhoto
        userIndex = userDictionary
        postIndex = postDictionary
    }*/
}

class User: Equatable{
    
    var fullName = String()
    var firstName = String()
    var picture = UIImage()
    var hasUniqueFirstName = true
    
    init(name: String, profilePicture: UIImage){
        fullName = name
        if let fName: String = name.componentsSeparatedByString(" ").first{
            firstName = fName
        }
        else{
            firstName = fullName
        }

        picture = profilePicture
        
    }
    init(){}
}


class LoggedInUser : User{
    var groups: [Group]?
    
    init(name: String, groupsJoined: [Group], profilePicture: UIImage){
        super.init(name: name, profilePicture: profilePicture)
        groups = groupsJoined
    }
}


class Post{
    
    var content: PostContent
    var postNumber: Int
    var userPosted: User
    var caption: String?
    var commentList: [Int: Comment]?
    var likers: [User]?
    
    init(){
        
        content = .TextPost("")
        postNumber = 0
        commentList = nil
        userPosted = User()
        caption = nil
        likers = nil
    }
    
    init(content: PostContent, postNumber: Int, userPosted: User, commentList: [Int: Comment]?, caption: String?){
        
        self.content = content
        self.postNumber = postNumber
        self.userPosted = userPosted
        self.caption = caption
        self.commentList = commentList
    }
}

struct Comment{
    var text: String
    var userPosted: User
}


internal enum PostContent{
    
    //The text
    case TextPost(String)
    
    //The image
    case PhotoPost(UIImage)
    
    //The path of the file. For example  NSBundle.mainBundle().pathForResource("Preview", ofType:"mp4") for Preview.mp4
    case VideoPost(String)
    
    //Only the Video ID
    case YoutubePost(String)
    
    //The link
    case ArticlePost(NSURL)
}



func ==(lhs: User, rhs: User) -> Bool{
    if(lhs.fullName == rhs.fullName && lhs.picture == rhs.picture){
        return true
    }
    return false
}

