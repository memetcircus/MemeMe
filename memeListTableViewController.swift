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
    
    private let reuseIdentifier = "memedCell"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedIndexInTableView : Int = 0
    
    @IBOutlet var memeListTableView: UITableView!
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let memes = appDelegate.memes
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)! as UITableViewCell
        let imageViewInCell : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let labelInCell : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        
        imageViewInCell.image = memes[indexPath.row].memedImage
        
        labelInCell.text = scaleLargeTextToTenCharacters(memes[indexPath.row].topText) + "..." + scaleLargeTextToTenCharacters(memes[indexPath.row].bottomText)
        
        return cell
    }
    
    ///scale bottom and top text to show in rows
    func scaleLargeTextToTenCharacters(string: String) -> String {
        
        let newString = string as NSString
        
        if newString.length > 10 {
            return newString.substringToIndex(10) as String
        }
        else{
            return newString as String
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        memeListTableView.reloadData()
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
        
        _ = appDelegate.memes
        selectedIndexInTableView = indexPath.row
        performSegueWithIdentifier("toDetailViewController", sender: self)
        
    }
    
    ///delete row
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        _ = appDelegate.memes
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            
            appDelegate.memes.removeAtIndex(indexPath.row)
            memeListTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    @IBAction func showMemeEditorViewController(sender: AnyObject) {
        
        performSegueWithIdentifier("toEditorViewController", sender: self)
    }
    
    
    
}