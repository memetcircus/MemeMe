//
//  Meme.swift
//  MemeMe
//
//  Created by Mehmet Akif Acar on 07/08/15.
//  Copyright (c) 2015 Memetcircus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Meme : NSManagedObject {
   
    @NSManaged var bottomText: String
    @NSManaged var topText: String
    @NSManaged var orgImage: NSData
    @NSManaged var memedImage: NSData
    @NSManaged var creationTime: NSDate

    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext){
        
        let entity =  NSEntityDescription.entityForName("Meme", inManagedObjectContext: context)!

        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        bottomText = dictionary["bottomText"] as! String
        topText = dictionary["topText"] as! String
        
        orgImage = UIImageJPEGRepresentation(dictionary["orgImage"] as! UIImage, 1)!
        memedImage = UIImageJPEGRepresentation(dictionary["memedImage"] as! UIImage, 1)!
        
        creationTime = NSDate()
    }
}
