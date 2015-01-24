//
//  Project.swift
//  timekipr
//
//  Created by dave on 10.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import CoreData

class Project: NSManagedObject {

    @NSManaged var color: String
    @NSManaged var name: String
    @NSManaged var projectTimeEntries: NSSet
    
    class func create(name: NSString, projectColor color: NSString, insertIntoManagedObjectContext context: NSManagedObjectContext) -> Project {
        let project = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: context) as Project
        project.name = name
        project.color = color
        return project
    }

}
