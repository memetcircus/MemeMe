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

class memeListTableViewController : UITableViewController, NSFetchedResultsControllerDelegate{
    
    private let reuseIdentifier = "memedCell"

    var selectedIndexInTableView : NSIndexPath!
    
    @IBOutlet var memeListTableView: UITableView!
    
    lazy var sharedContext: NSManagedObjectContext = {
        return CoreDataStackManager.sharedInstance().managedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Meme")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "creationTime", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: self.sharedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
        return fetchedResultsController
        
    }()
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        let sectionInfo = self.fetchedResultsController.sections![section]
        return (sectionInfo as NSFetchedResultsSectionInfo).numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meme = fetchedResultsController.objectAtIndexPath(indexPath) as! Meme
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier)! as UITableViewCell
        let imageViewInCell : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        let labelInCell : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        
        imageViewInCell.image = UIImage(data: meme.memedImage)
        
        labelInCell.text = scaleLargeTextToTenCharacters(meme.topText) + "..." + scaleLargeTextToTenCharacters(meme.bottomText)
        
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
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            
        }
        
        memeListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toDetailViewController" ){
 
            let meme = fetchedResultsController.objectAtIndexPath(selectedIndexInTableView) as! Meme
            
            let memeDetailViewCont = segue.destinationViewController as! MemeDetailViewController
            
            memeDetailViewCont.hidesBottomBarWhenPushed = true
          
            memeDetailViewCont.meme = meme
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndexInTableView = indexPath
        
        performSegueWithIdentifier("toDetailViewController", sender: self)
        
    }
    
    ///delete row
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete{
            let meme = fetchedResultsController.objectAtIndexPath(indexPath) as! Meme
            sharedContext.deleteObject(meme)
            CoreDataStackManager.sharedInstance().saveContext()
        }
    }
    
    @IBAction func showMemeEditorViewController(sender: AnyObject) {
        
        performSegueWithIdentifier("toEditorViewController", sender: self)
    }

    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeSection sectionInfo: NSFetchedResultsSectionInfo,
        atIndex sectionIndex: Int,
        forChangeType type: NSFetchedResultsChangeType) {
            
            switch type {
            case .Insert:
                self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            case .Delete:
                self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
                
            default:
                return
            }
    }
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            
            switch type {
            case .Insert:
                tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
                
            case .Delete:
                tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
                
            default:
                break
            }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
}