//
//  NewPostController.swift
//  Flock
//
//  Created by Oliver Hill on 3/23/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

class NewPostController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    var gc: GridController?
    
    var isFirstSubviewLayout = true
    
    var textButton = UIButton()
    var photoVideoButton = UIButton()
    var linkButton = UIButton()
    var allFlocksSwitch = UISwitch()
    
    var selectedButton = 1 { didSet{ selectionChanged(true) }}
    var selectedShader = UIView()
    
    //Content specific subviews
    var textField = UITextView()
    var linkCaptionField = UITextView()
    var linkField = UITextField()
    var captureButton = UIButton()
    var uploadButton = UIButton()
    var captureLabel = UILabel()
    var uploadLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewDidLayoutSubviews() {
        if isFirstSubviewLayout{
            addTopBar()
            addSwitch()
            addBottomBar()
            photoVideoButtonPressed()
            addPanGestureRecognizer()
            addObservers()
        }
    }
    
    //MARK: Add Permanent Subviews
    func addSwitch(){
        allFlocksSwitch = UISwitch(frame: Properties.allFlocksSwitchFrame(size: view.frame.size))
        allFlocksSwitch.alpha = 0.5
        allFlocksSwitch.addTarget(self, action: #selector(NewPostController.changeSwitchColor), forControlEvents: .ValueChanged)
        allFlocksSwitch.tintColor = Properties.tiltColor
        allFlocksSwitch.thumbTintColor = Properties.tiltColor
        allFlocksSwitch.onTintColor = Properties.tiltColor
        view.addSubview(allFlocksSwitch)
    
        let allFlocksLabel = UILabel(frame: Properties.allFlocksLabel(size: view.frame.size))
        allFlocksLabel.text = "Post to all Flocks"
        allFlocksLabel.font = Properties.allFlocksLabelFont
        allFlocksLabel.alpha = 0.5
        allFlocksLabel.textAlignment = .Left
        view.addSubview(allFlocksLabel)
        
    }
    
    func addTopBar(){
        
        let cancelButton = UIButton(frame: CGRect(x: 10, y: 10, width: 75, height: 50))
        cancelButton.titleLabel?.textAlignment = .Center
        cancelButton.setAttributedTitle(NSAttributedString(string: "Cancel"), forState: .Normal)
        cancelButton.alpha = 0.5
        cancelButton.setTitleColor(Properties.tiltColor, forState: .Normal)
        cancelButton.titleLabel?.font = Properties.postCategoryFont
        cancelButton.addTarget(self, action: #selector(NewPostController.cancelPressed), forControlEvents: .TouchUpInside)
        view.addSubview(cancelButton)
        
        let shareButton = UIButton(frame: CGRect(x: view.frame.size.width - 85, y: 10, width: 75, height: 50))
        shareButton.titleLabel?.textAlignment = .Center
        shareButton.setTitleColor(Properties.tiltColor, forState: .Normal)
        shareButton.setAttributedTitle(NSAttributedString(string: "Share"), forState: .Normal)
        shareButton.alpha = 0.5
        shareButton.titleLabel?.font = Properties.postCategoryFont
        shareButton.addTarget(presentingViewController, action: #selector(NewPostController.post), forControlEvents: .TouchUpInside)
        view.addSubview(shareButton)
        
    }
    
    func addBottomBar(){
       
        let buttonSize = CGSize(width:view.frame.width/3 , height: view.bounds.height/10)
        textButton.frame = CGRect(origin: CGPoint(x: 0, y: view.frame.maxY-buttonSize.height), size: buttonSize)
        textButton.titleLabel?.font = Properties.postCategoryFont
        textButton.titleLabel?.textAlignment = .Center
        textButton.setAttributedTitle(NSAttributedString(string: "Text"), forState: .Normal)
        textButton.setTitleColor(Properties.themeColor, forState: .Normal)
        textButton.addTarget(self, action: #selector(NewPostController.textButtonPressed), forControlEvents: .TouchUpInside)
        textButton.alpha = 0.5
        view.addSubview(textButton)
            
        photoVideoButton.frame = CGRect(origin: CGPoint(x: buttonSize.width, y: view.frame.maxY-buttonSize.height), size: buttonSize)
        photoVideoButton.titleLabel?.font = Properties.postCategoryFont
        photoVideoButton.titleLabel?.textAlignment
        photoVideoButton.setAttributedTitle(NSAttributedString(string: "Photo/Video"), forState: .Normal)
        photoVideoButton.setTitleColor(Properties.themeColor, forState: .Normal)
        photoVideoButton.addTarget(self, action: #selector(NewPostController.photoVideoButtonPressed), forControlEvents: .TouchUpInside)
        photoVideoButton.alpha = 0.5
        view.addSubview(photoVideoButton)
            
        linkButton.frame = CGRect(origin: CGPoint(x: buttonSize.width*2, y: view.frame.maxY-buttonSize.height), size: buttonSize)
        linkButton.titleLabel?.textAlignment = .Center
        linkButton.titleLabel?.font = Properties.postCategoryFont
        linkButton.setAttributedTitle(NSAttributedString(string: "Link"), forState: .Normal)
        linkButton.setTitleColor(Properties.themeColor, forState: .Normal)
        linkButton.addTarget(self, action: #selector(NewPostController.linkButtonPressed), forControlEvents: .TouchUpInside)
        linkButton.alpha = 0.5
        view.addSubview(linkButton)
            
        selectionChanged(false)
        
    }
    
    func addPanGestureRecognizer(){
        let swipe = UIPanGestureRecognizer(target: self, action: #selector(NewPostController.didSwipe(_:)))
        swipe.delegate = self
        view.addGestureRecognizer(swipe)
    }
    
    func didSwipe(recognizer: UIPanGestureRecognizer){
        if recognizer.state == .Ended{
            let point = recognizer.translationInView(view)
            //Horizontal Swipe
            if abs(point.x) >= abs(point.y){
                if point.x >= 0 && selectedButton != 0{
                
                    if selectedButton-1 == 0{
                        textButtonPressed()
                    }
                    else{
                        photoVideoButtonPressed()
                    }
                }
                else if point.x <= 0 && selectedButton != 2{
                   if selectedButton+1 == 1{
                        photoVideoButtonPressed()
                    }
                    else{
                        linkButtonPressed()
                    }
                }
            }
        }
    }
    
    
    //MARK: Control Event Handling
    //Top Bar Buttons
    func cancelPressed(){
        let navController = view.window!.rootViewController as! UINavigationController!
        navController.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func post(){
        //self.delegateController!.addPost()
        
    }
    
    //Bottom Bar Buttons
    func textButtonPressed(){
        
        selectedButton = 0
        
        textField = UITextView(frame: Properties.textFieldFrame(size: view.frame.size))
        textField.backgroundColor = Properties.tiltColor
        textField.alpha = 0.3
        textField.text = "Text Post: "
        textField.font = Properties.captionPostingFont
        textField.delegate = self
        view.addSubview(textField)
    }
    
    func photoVideoButtonPressed(){
        selectedButton = 1
        
        linkCaptionField = UITextView(frame: Properties.linkCaptionFieldFrame(size: view.frame.size))
        linkCaptionField.backgroundColor = Properties.tiltColor
        linkCaptionField.alpha = 0.3
        linkCaptionField.font = Properties.captionPostingFont
        linkCaptionField.delegate = self
        linkCaptionField.text = "Caption: "
        view.addSubview(linkCaptionField)
        
        uploadButton = UIButton(frame: Properties.uploadPhotoFrame(size: view.frame.size))
        uploadButton.setBackgroundImage(UIImage(imageLiteral: "Grid"), forState: .Normal)
        uploadButton.addTarget(self, action: #selector(NewPostController.uploadPhoto), forControlEvents: .TouchUpInside)
        view.addSubview(uploadButton)
        
        uploadLabel.frame = Properties.uploadLabelFrame(size: view.frame.size)
        uploadLabel.font = Properties.postCategoryFont
        uploadLabel.textAlignment = .Center
        uploadLabel.text = "Upload"
        uploadLabel.alpha = 0.4
        view.addSubview(uploadLabel)
        
        captureButton = UIButton(frame: Properties.capturePhotoFrame(size: view.frame.size))
        captureButton.setBackgroundImage(UIImage(imageLiteral: "Capture"), forState: .Normal)
        captureButton.addTarget(self, action: (#selector(NewPostController.capturePhoto)), forControlEvents: .TouchUpInside)
        view.addSubview(captureButton)
        
        captureLabel.frame = Properties.captureLabelFrame(size: view.frame.size)
        captureLabel.font = Properties.postCategoryFont
        captureLabel.textAlignment = .Center
        captureLabel.text = "Capture"
        captureLabel.alpha = 0.4
        view.addSubview(captureLabel)
        
        isFirstSubviewLayout = false
        
        
    }
    
    func linkButtonPressed(){
        selectedButton = 2
        
        linkCaptionField = UITextView(frame: Properties.linkCaptionFieldFrame(size: view.frame.size))
        linkCaptionField.backgroundColor = Properties.tiltColor
        linkCaptionField.alpha = 0.3
        linkCaptionField.font = Properties.captionPostingFont
        linkCaptionField.returnKeyType = .Done
        linkCaptionField.delegate = self
        linkCaptionField.text = "Caption: "
        view.addSubview(linkCaptionField)
        
        linkField = UITextField(frame: Properties.linkFieldFrame(size: view.frame.size))
        linkField.text = " Link: "
        linkField.alpha = 0.3
        linkField.backgroundColor = Properties.tiltColor
        linkField.delegate = self
        linkField.font = Properties.captionPostingFont
        view.addSubview(linkField)

    }
    
    func uploadPhoto(){
        //TODO: UIImagePicker shit here
    }
    func capturePhoto(){
        
    }
    
    //MARK: Screen Switching
    func selectionChanged(shouldAnimate: Bool){
        let shaderSize = CGSize(width:view.frame.width/3 , height: view.bounds.height/60)
        let originY: CGFloat = view.frame.maxY-shaderSize.height
        var frame = CGRectZero
        switch selectedButton{
        case 0:
            frame = CGRect(origin: CGPoint(x: 0, y: originY), size: shaderSize)
        case 1:
            frame = CGRect(origin: CGPoint(x: shaderSize.width, y: originY), size: shaderSize)
        case 2:
            frame = CGRect(origin: CGPoint(x: shaderSize.width*2, y: originY), size: shaderSize)
        default:break
        }
        if !shouldAnimate{
            selectedShader = UIView(frame: frame)
            selectedShader.alpha = 0.5
            selectedShader.backgroundColor = Properties.themeColor
            view.addSubview(selectedShader)
        }
        else{
           
            UIView.animateWithDuration(0.25,
                delay: 0.0,
                usingSpringWithDamping: 0.5,
                initialSpringVelocity: 0.5,
                options: [],
                animations: {self.selectedShader.frame = frame}, completion: nil)
    
        }
        clearBackground()
    }
    
    func changeSwitchColor(){
        
       if allFlocksSwitch.on {
            allFlocksSwitch.thumbTintColor = UIColor.whiteColor()
        }
        else{
            allFlocksSwitch.thumbTintColor = Properties.tiltColor
        }
    }

    func clearBackground(){
        textField.removeFromSuperview()
        linkCaptionField.removeFromSuperview()
        linkField.removeFromSuperview()
        uploadButton.removeFromSuperview()
        captureButton.removeFromSuperview()
        uploadLabel.removeFromSuperview()
        captureLabel.removeFromSuperview()
    }
    
    //MARK: Keyboard Management
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        textView.text = ""
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    func textViewShouldReturn(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // 1. dismisses keyboard when enter key is pressed
        textField.resignFirstResponder()
      
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 2. dismisses keyboard when user taps elsewhere
        textField.resignFirstResponder()
        linkField.resignFirstResponder()
        linkCaptionField.resignFirstResponder()
    }
    
    func addObservers(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewPostController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(NewPostController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillShow(notification: NSNotification) {
      //  if let shouldMove: Bool = keyboardShouldMoveScreen{
     //       if shouldMove{
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    self.view.frame.origin.y -= keyboardSize.height
                }
     //       }
     //   }
    }
    
    func keyboardWillHide(notification: NSNotification) {
      //  if let shouldMove: Bool = keyboardShouldMoveScreen{
      //      if shouldMove{
                if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                    self.view.frame.origin.y += keyboardSize.height
                }
            }
     //   }
    //}

}
