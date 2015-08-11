//
//  memeListTableViewController.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 08/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import Foundation
import UIKit

class memeListTableViewController : UITableViewController{
    
    @IBOutlet var memeListTableView: UITableView!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

    var selectedIndexInTableView : Int = 0
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let memes = appDelegate.memes
        
        let cell = tableView.dequeueReusableCellWithIdentifier("memedCell") as! UITableViewCell
        
        let imageViewInCell : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        let labelInCell : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        
        imageViewInCell.image = memes[indexPath.row].memedImage
        
        //imageViewInCell.image = self.scaleImage(memes[indexPath.row].memedImage, resolution: 200.0)
        
        var topText : NSString = memes[indexPath.row].topText as NSString
        
        if topText.length > 10 {
            topText = (memes[indexPath.row].topText as NSString).substringToIndex(10)
        }
        else{
            topText = memes[indexPath.row].topText
        }
        
        var bottomText : NSString = memes[indexPath.row].bottomText as NSString
        
        if bottomText.length > 10 {
            bottomText = (memes[indexPath.row].bottomText as NSString).substringToIndex(10)
        }
        else{
            bottomText = memes[indexPath.row].bottomText
        }
        
         labelInCell.text = (topText as String) + "..." + (bottomText as String)
        
        return cell
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeListTableView.reloadData()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toDetailViewController" ){
        
            let memes = appDelegate.memes
        
            let memeDetailViewCont = segue.destinationViewController as! MemeDetailViewController
        
            memeDetailViewCont.hidesBottomBarWhenPushed = true
        
            memeDetailViewCont.meme = memes[selectedIndexInTableView]
        }
        
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let memes = appDelegate.memes
        
//        //toDetailViewController
//        
//        let memeDetailViewCont = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        
//        
//        memeDetailViewCont.meme = memes[indexPath.row]
//        
//        memeDetailViewCont.hidesBottomBarWhenPushed = true
        
        selectedIndexInTableView = indexPath.row
        
        self.performSegueWithIdentifier("toDetailViewController", sender: self)
        
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
         let memes = appDelegate.memes
        if editingStyle == UITableViewCellEditingStyle.Delete{
            appDelegate.memes.removeAtIndex(indexPath.row)
            self.memeListTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            //self.memeListTableView.reloadData()
            
        }
        
    }
    
    @IBAction func showMemeEditorViewController(sender: AnyObject) {
        
         self.performSegueWithIdentifier("toEditorViewController", sender: self)
    }
//    func scaleImage(image: UIImage, resolution: CGFloat) -> UIImage{
//        let imgRef : CGImageRef = image as! CGImage
//        let width : CGFloat = image.size.width
//        let height : CGFloat = image.size.height
//        var bounds : CGRect = CGRectMake(0, 0, width, height)
//        let ratio : CGFloat
//        
//        if (width <= resolution) && (height <= resolution) {
//            return image
//        }else{
//            ratio  = width / height
//        }
//        
//        if (ratio > 1) {
//            bounds.size.width = resolution
//            bounds.size.height = bounds.size.width / ratio
//        }else{
//            bounds.size.height = resolution
//            bounds.size.width = bounds.size.height * ratio
//        }
//        
//        UIGraphicsBeginImageContext(bounds.size)
//        image.drawInRect(CGRectMake(0.0, 0.0, bounds.size.width, bounds.size.height))
//        let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        
//        return newImage
//    }
    
    
    
}