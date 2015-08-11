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
    
        imageView.image = meme.memedImage
    }
    
    @IBAction func unwindToDetailViewController(segue: UIStoryboardSegue){
     
        self.dismissViewControllerAnimated(true, completion: {() -> Void in
            self.navigationController?.popViewControllerAnimated(false)
        
            } )
    }
    
    @IBAction func showMemeEditorViewController(sender: AnyObject) {
         var storyboard = UIStoryboard (name: "Main", bundle: nil)
        
        var editorVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditorVC") as! MemeEditorViewController
        
        self.navigationController?.presentViewController(editorVC, animated: true, completion: {() -> Void in
            
                editorVC.topTextField.text = self.meme.topText
                editorVC.bottomTextField.text = self.meme.bottomText
                editorVC.imagePickerView.image = self.meme.orgImage
            
                editorVC.actionTopToolBarItem.enabled = true
            
                editorVC.isEditButtonTouchedInDetailViewCont = true
            }
            
)}
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//        if (segue.identifier == "ToEditorViewController" ){
//    
////            var memeEditorViewCont : MemeEditorViewController = MemeEditorViewController()
////            
////            memeEditorViewCont = segue.destinationViewController as! MemeEditorViewController
////            
////            memeEditorViewCont.topText = meme.topText
////            
////            memeEditorViewCont.bottomText = meme.bottomText
////            
////            memeEditorViewCont.image = meme.orgImage
//            
//        }
//        
//    }
}
