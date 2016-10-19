//
//  GroupController.swift
//  Flock
//
//  Created by Oliver Hill on 3/8/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

class GroupController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    var user: LoggedInUser!
    var tableView = UITableView()
    var navController = UINavigationController()
    var lastGroup: Group?

    
    
    //MARK: Life Cycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        //temporary hard coding
        garbage()
        navigationBarSetup()
        view.backgroundColor = UIColor.whiteColor()
        tableViewSetup()
        addPanGestureRecognizer()
    }
    
    
    //MARK: TableView Functions
    
    //Number of rows in section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.groups!.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Properties.flockCellHeight
    }
    
    //Cell for row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FlockCell")! as! FlockCell
        let thisGroup = user.groups![indexPath.item]
        var imgArray = [UIImage]()
        var count = 0
        for (_, person) in thisGroup.userIndex{
            if count <= 4 && person.fullName != user.fullName{
                    imgArray.append(person.picture)
                }
            count+=1

        }
        cell.clearData()
        cell.loadData(thisGroup.name, groupPicture: thisGroup.photo, firstMembers: imgArray, newPosts: true)
        return cell
    }
    
    //Did select row
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navController.navigationBar.translucent = false
        navController.navigationBar.backItem?.backBarButtonItem?.enabled = false
        let gc = GridController()
        let selectedGroup = user.groups![indexPath.item]
        gc.group = selectedGroup
        lastGroup = selectedGroup
        navController.pushViewController(gc, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    
    //MARK: Subview Setup
    func navigationBarSetup(){
        navigationItem.title = "Flocks"
        navController.navigationBar.translucent = false
        navController = view.window!.rootViewController as! UINavigationController
        
        let plusButton = UIButton(type: .Custom)
        plusButton.setImage(UIImage(imageLiteral: "Plus"), forState:  .Normal)
        plusButton.addTarget(self, action: #selector(GroupController.newFlock), forControlEvents: .TouchUpInside)
        plusButton.frame = CGRect(x: 0 , y: 0, width: 25, height: 25)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: plusButton)
        
        let settingsButton = UIButton(type: .Custom)
        settingsButton.setImage(UIImage(imageLiteral: "cog"), forState: .Normal)
        settingsButton.addTarget(self, action: #selector(GroupController.settingsPressed), forControlEvents: .TouchUpInside)
        settingsButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)

    }
    
    func tableViewSetup(){
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - (navController.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(FlockCell.self, forCellReuseIdentifier: "FlockCell")
        self.view.addSubview(tableView)
    }
    
    func garbage(){
        let cbj = Group()
        cbj.name = "High School Homies"
        let fam = Group()
        fam.name = "Fam"
        let lightskin = Group()
        lightskin.name = "Team Lightskin"
        let tellers = Group()
        tellers.name = "Spring Tellers '16"
        
        
        
        
        let oliver = User(name: "Oliver Hill", profilePicture: UIImage(imageLiteral: "Oliver"))
        let jack = User(name: "Jack Damon", profilePicture: UIImage(imageLiteral: "Jack"))
        let charlie = User(name: "Charlie Brahaney", profilePicture: UIImage(imageLiteral: "Charlie"))
        let max = User(name: "Max Mcevoy", profilePicture: UIImage(imageLiteral: "Max"))
        let henry = User(name: "Henry Decamp", profilePicture: UIImage(imageLiteral: "Henry"))
        
        let cat = NSBundle.mainBundle().pathForResource("Preview", ofType: "mp4")
        

        cbj.postIndex = [0:Post(content: .PhotoPost(UIImage(imageLiteral: "img1")), postNumber: 0, userPosted: oliver, commentList: [0:Comment(text: "Dope Pic Bro",userPosted: oliver)], caption: "lol"),
            1:Post(content: .TextPost("Yo guys this app is fire"), postNumber: 1, userPosted: jack, commentList: nil, caption: nil),
            2:Post(content: .TextPost("I know dog"), postNumber: 2, userPosted: oliver, commentList: nil, caption: nil),
            3:Post(content: .PhotoPost(UIImage(imageLiteral: "img2")), postNumber: 3, userPosted: oliver, commentList: [0:Comment(text: "Dope Pic Bro",userPosted: oliver)], caption: nil),
            4:Post(content: .PhotoPost(UIImage(imageLiteral: "img10")), postNumber: 4, userPosted: oliver, commentList: nil, caption: "I want this wolf"),
            5:Post(content: .PhotoPost(UIImage(imageLiteral: "img3")), postNumber: 5, userPosted: oliver, commentList: nil, caption: nil),
            6:Post(content: .TextPost("God Damn I love Flock"), postNumber: 6, userPosted: oliver, commentList: nil, caption: nil),
            
            7:Post(content: .YoutubePost("IjbMxTvupH0"), postNumber: 7, userPosted: henry, commentList: nil, caption: nil),
            8:Post(content: .TextPost("When are you guys out of school?"), postNumber: 8, userPosted: max, commentList: nil, caption: nil),
            9:Post(content: .YoutubePost("DnpO_RTSNmQ"), postNumber: 9, userPosted: charlie, commentList: nil, caption: nil),
            10:Post(content: .VideoPost(cat!), postNumber: 10, userPosted: jack, commentList: nil, caption: nil),
            11:Post(content: .PhotoPost(UIImage(imageLiteral: "img6")), postNumber: 11, userPosted: henry, commentList: nil, caption: nil),
            12:Post(content: .YoutubePost("kotWv4MCxNI"), postNumber: 12, userPosted: henry, commentList: nil, caption: "lmao this thing wheels")
        ]
        
        cbj.photo = UIImage(imageLiteral: "CBJ")
        cbj.name = "High School Homies"
        cbj.userIndex = [0:oliver, 1:jack, 2: max, 3:henry, 4:charlie]
        
        
        let gareth = User(name: "Gareth Hill", profilePicture: UIImage(imageLiteral: "Gareth"))
        let mom = User(name: "Leith Hill", profilePicture: UIImage(imageLiteral: "Mom"))
        let dad = User(name: "John Hill", profilePicture: UIImage(imageLiteral: "Dad"))
        fam.userIndex = [0: mom, 1: dad, 2: gareth, 3: oliver]
        fam.photo = UIImage(imageLiteral: "Fam")
    
        
        let founders = Group()
        founders.name = "Founders"
        founders.photo = UIImage(imageLiteral: "founderProf")
        founders.userIndex = [0:oliver, 1:jack]

        
        lightskin.photo = UIImage(imageLiteral: "hIsland")
        lightskin.name = "New South 4th Floor"
        let sam = User()
        sam.picture = UIImage(imageLiteral: "sam")
        
        let kemi = User()
        kemi.picture = UIImage(imageLiteral: "kemi")
        
        let tejas = User()
        tejas.picture = UIImage(imageLiteral: "tejas")
        lightskin.userIndex = [0:mom, 1:sam, 2:kemi, 3:tejas, 4: henry]
        user = LoggedInUser(name: "Oliver Hill", groupsJoined: [cbj, fam, founders, lightskin], profilePicture: UIImage(imageLiteral: "Oliver"))
        
        let dog = NSBundle.mainBundle().pathForResource("Driver", ofType: "mov")
        
        founders.postIndex = [
            
            12:Post(content: .TextPost("Hello World"), postNumber: 12, userPosted: oliver, commentList: [0:Comment(text: "Hello World",userPosted: oliver)], caption: nil),
            1:Post(content: .PhotoPost(UIImage(imageLiteral: "j+o")), postNumber: 1, userPosted: jack, commentList: nil, caption: "Tbt"),
            
            2:Post(content: .YoutubePost("btLyeTSMWKU"), postNumber: 2, userPosted: jack, commentList: nil, caption: "Preach it Kanye"),
            
            4:Post(content: .YoutubePost("XrhmepZlCWY"), postNumber: 4, userPosted: oliver, commentList: [0:Comment(text: "Dope Pic Bro",userPosted: oliver)], caption: "Skip to 4:05... the Woz gets it."),
            
            6:Post(content: .YoutubePost("YIdvEUxCN5o"), postNumber: 6, userPosted: jack, commentList: nil, caption: "Obama gettin real nervous"),
            
            3:Post(content: .TextPost("So hyped for this weekend"), postNumber: 3, userPosted: oliver, commentList: nil, caption: nil),
            0:Post(content: .PhotoPost(UIImage(imageLiteral: "night")), postNumber: 0, userPosted: jack, commentList: nil, caption: "Unreal night"),
            5:Post(content: .PhotoPost(UIImage(imageLiteral: "logo")), postNumber: 5, userPosted: jack, commentList: nil, caption: "Final Logo :)"),
            7:Post(content: .VideoPost(dog!), postNumber: 7, userPosted: oliver, commentList: nil, caption: "RIP driver"),
            8:Post(content: .YoutubePost("CBYhVcO4WgI"), postNumber: 8, userPosted: oliver, commentList: nil, caption: nil),
            9:Post(content: .YoutubePost("iavquu6PP9g"), postNumber: 9, userPosted: jack, commentList: nil, caption: nil),
            10:Post(content: .TextPost("10 days til deadline"), postNumber: 10, userPosted: oliver, commentList: nil, caption: nil),
            11:Post(content: .PhotoPost(UIImage(imageLiteral: "hIsland")), postNumber: 11, userPosted: jack, commentList: nil, caption: nil),
            13:Post(content: .ArticlePost(NSURL(string: "https://www.ycombinator.com")!), postNumber: 13, userPosted: oliver, commentList: nil, caption: "Check out this article")
            ]
    }
    
    //TODO:
    func newFlock(){
        
    }
    
    //TODO:
    func settingsPressed(){
        
    }
    
    
    func addPanGestureRecognizer(){
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(GroupController.didSwipe(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
    }
    
    func didSwipe(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .Ended{
            let point = recognizer.translationInView(view)
            //Horizontal Swipe
            if abs(point.x) >= abs(point.y) && point.x <= 0{
                
                let gc = GridController()
                if lastGroup != nil{
                    gc.group = lastGroup
                }
                else{
                    gc.group = user.groups!.first
                }
                navController.pushViewController(gc, animated: true)
            }
        }
     }
  }
