//
//  memeListCollectionViewController.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 08/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import Foundation
import UIKit

class memeListCollectionViewController : UICollectionViewController{
    
    private let reuseIdentifier = "MemeMeCollectionCell"
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet var memeCollectionView: UICollectionView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.memeCollectionView.reloadData()
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        let memes = appDelegate.memes
        
        cell.imageView.image = memes[indexPath.row].memedImage
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let memes = appDelegate.memes
        let memeDetailViewCont = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        memeDetailViewCont.meme = memes[indexPath.row]
        memeDetailViewCont.hidesBottomBarWhenPushed = true
        
        self.navigationController!.pushViewController(memeDetailViewCont, animated: true)
    }

    
    
}