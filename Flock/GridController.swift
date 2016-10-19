//
//  GridController.swift
//  Flock
//
//  Created by Oliver Hill on 2/26/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

class GridController: UIViewController, UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource, UIGestureRecognizerDelegate,
UIPopoverPresentationControllerDelegate {
    
    
    //MARK: Properties
    var group: Group!
    
    var gridView: UICollectionView!
    var peopleView: UICollectionView!
    var headerView: UIView!
    var bottomBorder: CALayer!
    var separator: CALayer!
    
    var userPressed: User? {
        didSet{
            gridView.reloadData();
            peopleView.reloadData()
        }
    }
    var subContent = [Int: Post]()
   
    var fromGroupView = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetup()
        headerViewSetup()
        groupPhotoSetup()
        gridViewSetup()
        peopleViewSetup()
        addBorder()
        addPanGestureRecognizer()

    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    //MARK: CollectionView Methods
    //Minimum Spacing
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    //Number of Items in Section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == gridView){
            if userPressed == nil{
                return group.postIndex.count+1
            }
            else{
                return subContent.count
            }
        }
        else{
            return group.userIndex.count+1
        }
    }
    
    //Item Selected
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //GridView selection: transition to stack view
        
        if collectionView == gridView{
            if let post: Post = group.postIndex[indexPath.item-1]{
            
                switch post.content{
                case .ArticlePost:
                    let tc = TheaterController()
                    tc.post = post
                    let btn = UIBarButtonItem(title: "", style: .Plain, target: self, action: nil)
                    
                    self.navigationController?.navigationBar.topItem?.backBarButtonItem=btn
                    navigationController!.pushViewController(tc, animated: true)
                    
                    
                
                default:
                    if userPressed != nil{
                        let sc = StackController(withHistory: subContent, onPost: indexPath.item)
                        sc.modalTransitionStyle = .CrossDissolve
                        presentViewController(sc, animated: true, completion: nil)
                    }
                        
                    else{
                        let sc = StackController(withHistory: group.postIndex, onPost: post.postNumber)
                        sc.modalTransitionStyle = .CrossDissolve
                        presentViewController(sc, animated: true, completion: nil)
                    }
                }
            }
                
            //New Post Selection
            else{
                presentNewPostMenu(gridView.bounds)
            }
        }
        
        else{
            //PeopleView selection: fill subcontent (selection is not the one thats already pressed)
            if userPressed != group.userIndex[indexPath.item]{
                userPressed = group.userIndex[indexPath.item]
                subContent.removeAll()
                var i = 0
                for (_,post) in group.postIndex{
                    if post.userPosted ==  userPressed!{
                        subContent[i] = post
                        i+=1
                   }
                }
            }
            else{
                groupPhotoPressed()
            }
        }
    }
    
    
    //Cell For Item
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //GridView
        if collectionView == gridView{
            let cell  = gridView.dequeueReusableCellWithReuseIdentifier(Properties.gridReuseIdentifier, forIndexPath: indexPath) as! PostCell
            if userPressed == nil{
                if indexPath.item == 0{
                    cell.loadData(.PhotoPost(UIImage(imageLiteral: "Plus")))
                }
                else{
                    cell.loadData(group.postIndex[indexPath.item-1]?.content)
                }
                return cell
            }
        
            else{
                if indexPath.item < subContent.count{
                    cell.loadData(subContent[indexPath.item]?.content)
                    return cell
                }
                return cell
            }
        }
        //PeopleView
        else{
            let cell = peopleView.dequeueReusableCellWithReuseIdentifier(Properties.peopleReuseIdentifier, forIndexPath: indexPath)
        
            let picture = group.userIndex[indexPath.item]?.picture
            if picture == nil{
                for subview in cell.subviews{
                    subview.removeFromSuperview()
                }
                //TODO: Taken away for demo
                /*cell.backgroundColor = Properties.themeColor
                picture = UIImage(imageLiteral: "WhitePlus")
                cell.frame.size = Properties.peopleCellSize*/
               
            }
            let pictureView = UIImageView(frame: cell.bounds)
            pictureView.image = picture
            cell.layer.cornerRadius = cell.bounds.size.width/2
            cell.clipsToBounds = true
            cell.addSubview(pictureView)
            if userPressed != nil && group.userIndex[indexPath.item] != userPressed{
                cell.alpha = 0.4
            }
            return cell
        }
    }
    
    
    //MARK: Subview Setups

    func navigationBarSetup(){
        navigationItem.hidesBackButton = true
        navigationItem.title = group.name
        
    
        let peopleButton = UIButton(type: .Custom)
        peopleButton.setImage(UIImage(imageLiteral: "People"), forState:  .Normal)
        peopleButton.addTarget(self, action: #selector(GridController.peopleButtonPressed), forControlEvents: .TouchUpInside)
        peopleButton.frame = CGRect(x: 0 , y: 0, width: 25, height: 25)
        peopleButton.layer.cornerRadius = peopleButton.frame.size.width/2
        peopleButton.clipsToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: peopleButton)
        
    }
    
    func groupPhotoSetup(){

        let groupImageView = UIImageView(frame: Properties.groupPhotoFrame)
        groupImageView.image = group.photo
        groupImageView.layer.cornerRadius = groupImageView.frame.size.width/2
        groupImageView.clipsToBounds = true
        headerView.addSubview(groupImageView)
        
        let groupButton = UIButton(frame: Properties.groupPhotoFrame)
        groupButton.addTarget(self, action: #selector(GridController.groupPhotoPressed), forControlEvents: .TouchUpInside)
        headerView.addSubview(groupButton)
        
        separator = CALayer()
        separator.frame = CGRect(x: Properties.headerHeight-1, y: 0, width: 1, height: Properties.headerHeight)
        separator.backgroundColor = Properties.themeColor.CGColor
        view.layer.addSublayer(separator)
        

    }
    
    func headerViewSetup(){
     
        headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: Properties.headerHeight))
        headerView.backgroundColor = UIColor.whiteColor()
        view.addSubview(headerView)
    }
    
    func gridViewSetup(){
        
        //GridLayout Setup
        let gridLayout = UICollectionViewFlowLayout()
        gridLayout.sectionInset = Properties.gridInsets
        gridLayout.itemSize = Properties.gridCellSize
        gridLayout.scrollDirection = .Vertical
        
        //GridView Setup
        let gridViewFrame = CGRect(origin: CGPoint(x: 0, y:Properties.headerHeight),
            size: CGSize(width: view.frame.width, height: view.frame.height-(Properties.headerHeight + 44)))
        gridView = UICollectionView(frame: gridViewFrame, collectionViewLayout: gridLayout)
        gridView.dataSource = self
        gridView.delegate = self
        gridView.registerClass(PostCell.self, forCellWithReuseIdentifier: Properties.gridReuseIdentifier)
        gridView.backgroundColor = UIColor.whiteColor()
        gridView.showsVerticalScrollIndicator = false
        view.addSubview(gridView)

    }
    
    func peopleViewSetup(){
        //People Layout Setup
        let peopleLayout = UICollectionViewFlowLayout()
        peopleLayout.sectionInset = Properties.peopleInsets
        peopleLayout.itemSize = Properties.peopleCellSize
        peopleLayout.scrollDirection = .Horizontal
        
        //PeopleView Setup
        peopleView = UICollectionView(frame: Properties.peopleViewFrame(view.frame.size.width), collectionViewLayout: peopleLayout)
        peopleView.dataSource = self
        peopleView.delegate = self
        peopleView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: Properties.peopleReuseIdentifier)
        peopleView.backgroundColor = UIColor.whiteColor()
        peopleView.showsHorizontalScrollIndicator = false
        headerView.addSubview(peopleView)

    }
    
    func addBorder(){
        //Border seperating peopleView and gridView
        bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: Properties.headerHeight, width: view.frame.size.width, height: 1)
        bottomBorder.backgroundColor = Properties.themeColor.CGColor
        view.layer.addSublayer(bottomBorder)
    }
    
    
    func groupPhotoPressed(){
        if userPressed != nil{
            userPressed = nil
        }
    }
    
    //Reveals or hides the peopleView grid
    func peopleButtonPressed(){
        
        if view.subviews.contains(headerView){
            UIView.animateWithDuration(0.25,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 5,
                options: [],
                animations: {self.gridView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)},
                completion: nil)
            bottomBorder.removeFromSuperlayer()
            headerView.removeFromSuperview()
            separator.removeFromSuperlayer()
        }
        else{
            headerViewSetup()
            groupPhotoSetup()
            peopleViewSetup()
            addBorder()
            UIView.animateWithDuration(0.25,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 5,
                options: [],
                animations: {self.gridView.frame = CGRect(origin: CGPoint(x: 0, y:Properties.headerHeight),
                    size: CGSize(width: self.view.frame.width, height: self.view.frame.height-Properties.headerHeight))},
                completion: nil)
        }
    }

    //MARK: Gesture Handling
    func addPanGestureRecognizer(){
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(GridController.didSwipe(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
    }
    
    func didSwipe(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .Ended{
            let point = recognizer.translationInView(view)
            //Horizontal Swipe
            if abs(point.x) >= abs(point.y) && point.x >= 0{
                let navController = view.window!.rootViewController as! UINavigationController
                navController.popViewControllerAnimated(true)
            }
        }
    }
    
    //MARK: New Post Popover Control
    func presentNewPostMenu(sourceRect: CGRect){
        let npc = NewPostController()
        npc.modalPresentationStyle = .Popover
        npc.popoverPresentationController?.delegate = self
        npc.preferredContentSize = CGSize(width: view.frame.width, height: gridView.bounds.height)
        npc.popoverPresentationController?.sourceView = view
        npc.popoverPresentationController?.sourceRect = peopleView.bounds
        npc.navigationController?.navigationBar.translucent = false
        npc.view.frame.size = npc.preferredContentSize
        presentViewController(npc, animated: true, completion: nil)
        
       // npc.delegateController = self
       // let navController = view.window!.rootViewController as! UINavigationController
       // navController.pushViewController(npc, animated: true)
        
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
   
    func presentationController(controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navController = view.window!.rootViewController as! UINavigationController
        return navController.presentedViewController
    }
    

    
}

