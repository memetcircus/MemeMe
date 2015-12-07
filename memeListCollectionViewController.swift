//
//  memeListCollectionViewController.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 08/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class memeListCollectionViewController : UICollectionViewController, NSFetchedResultsControllerDelegate{
    
    //var memes: [Meme]!
    
    private let reuseIdentifier = "MemeMeCollectionCell"
    
    //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var memeCollectionView: UICollectionView!
    
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        do{
            try fetchedResultsController.performFetch()
        }catch{
            
        }
        //memes = fetchAllMemes()
        
        memeCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return memes.count
        let sectionInfo = self.fetchedResultsController.sections![section]
        return (sectionInfo as NSFetchedResultsSectionInfo).numberOfObjects
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let meme = fetchedResultsController.objectAtIndexPath(indexPath) as! Meme
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        
        cell.imageView.image = UIImage(data: meme.memedImage)
        
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let meme = fetchedResultsController.objectAtIndexPath(indexPath) as! Meme
        
        let memeDetailViewCont = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
       // memeDetailViewCont.meme = memes[indexPath.row]
        memeDetailViewCont.meme = meme
        
        memeDetailViewCont.hidesBottomBarWhenPushed = true
        
        navigationController!.pushViewController(memeDetailViewCont, animated: true)
    }
    
//    func fetchAllMemes() -> [Meme]{
//        
//        let fetchRequest = NSFetchRequest(entityName: "Meme")
//        
//        do{
//            return try sharedContext.executeFetchRequest(fetchRequest) as! [Meme]
//            
//        }catch let error as NSError{
//            print("Error in fetchAllMemes():\(error)")
//            return [Meme]()
//        }
//    }
}