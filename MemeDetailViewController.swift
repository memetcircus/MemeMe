//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 09/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    
    var meme: Meme!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        imageView.image = UIImage(data: meme.memedImage)
    }
    
    ///turn to lists views
    @IBAction func unwindToDetailViewController(segue: UIStoryboardSegue){
        
        dismissViewControllerAnimated(true, completion: {() -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
    }
    
    @IBAction func showMemeEditorViewController(sender: AnyObject) {
        
        let storyboard = UIStoryboard (name: "Main", bundle: nil)
        
        let editorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
        
        editorVC.topText = meme.topText
        editorVC.bottomText = meme.bottomText
        editorVC.image = UIImage(data: meme.orgImage)
        editorVC.isEditButtonTouchedInDetailViewCont = true
        
        navigationController?.presentViewController(editorVC, animated: true, completion:nil)
        
    }
}
