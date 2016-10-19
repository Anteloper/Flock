//
//  CommentsController.swift
//  Flock
//
//  Created by Oliver Hill on 3/27/16.
//  Copyright © 2016 Oliver Hill. All rights reserved.
//

import UIKit

class CommentsController: UIViewController {
    override func viewDidLoad(){
        view.backgroundColor = Properties.tiltColor
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
