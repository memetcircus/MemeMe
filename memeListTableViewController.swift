//
//  memeListTableViewController.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 08/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class memeListTableViewController : UITableViewController{
    
    var memes: [Meme]!
    
    private let reuseIdentifier = "memedCell"
    
    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectedIndexInTableView : Int = 0
    
    @IBOutlet var memeListTableView: UITableView!
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
       
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)! as UITableViewCell
        let imageViewInCell : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let labelInCell : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        
        imageViewInCell.image = UIImage(data: memes[indexPath.row].memedImage)
        
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
        
        memes = fetchAllMemes()
        memeListTableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toDetailViewController" ){
 
            let memeDetailViewCont = segue.destinationViewController as! MemeDetailViewController
            
            memeDetailViewCont.hidesBottomBarWhenPushed = true
            memeDetailViewCont.meme = memes[selectedIndexInTableView]
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndexInTableView = indexPath.row
        performSegueWithIdentifier("toDetailViewController", sender: self)
        
    }
    
    ///delete row
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            let memeToBeDeleted = memes[indexPath.row]
            memes.removeAtIndex(indexPath.row)
            memeListTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            sharedContext.deleteObject(memeToBeDeleted)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    @IBAction func showMemeEditorViewController(sender: AnyObject) {
        
        performSegueWithIdentifier("toEditorViewController", sender: self)
    }
    
    func fetchAllMemes() -> [Meme]{
        
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        
        do{
            return try sharedContext.executeFetchRequest(fetchRequest) as! [Meme]
            
        }catch let error as NSError{
            print("Error in fetchAllMemes():\(error)")
            return [Meme]()
        }
    }
    
}