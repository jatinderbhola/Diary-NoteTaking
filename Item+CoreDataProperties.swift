//
//  Item+CoreDataProperties.swift
//  NoteTaking
//
//  Created by macadmin on 2015-10-26.
//  Copyright © 2015 Project. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Item {

    @NSManaged var date: String?
    @NSManaged var image: NSData?
    @NSManaged var latitude: NSNumber?
    @NSManaged var note: String?
    @NSManaged var subject: String?
    @NSManaged var longitude: NSNumber?

}
