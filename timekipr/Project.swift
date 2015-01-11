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
    
    class func create(name: NSString, projectColor color: NSString?, insertIntoManagedObjectContext context: NSManagedObjectContext) -> Project {
        let project = NSEntityDescription.insertNewObjectForEntityForName("Project", inManagedObjectContext: context) as Project
        project.name = name
        if let optionalColor = color {
            project.color = optionalColor
        }
        context.save(nil)
        return project
    }

}
