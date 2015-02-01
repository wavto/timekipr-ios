//
//  TimeEntry.swift
//  timekipr
//
//  Created by dave on 10.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import CoreData

class TimeEntry: NSManagedObject {

    @NSManaged var end: NSDate?
    @NSManaged var start: NSDate
    @NSManaged var timeEntryProject: Project
    
    class func create(start: NSDate, timeEntryProject project: Project, insertIntoManagedObjectContext context: NSManagedObjectContext) -> TimeEntry {
        let timeEntry = NSEntityDescription.insertNewObjectForEntityForName("TimeEntry", inManagedObjectContext: context) as TimeEntry
        timeEntry.start = start
        timeEntry.timeEntryProject = project
        return timeEntry
    }
    
    func getTotalTime(showTotalForCurrentTime showCurrent: Bool) -> Double {
        var total: Double = 0
        if self.end != nil {
            total = -self.start.timeIntervalSinceDate(self.end!)
        } else if showCurrent {
            total = -self.start.timeIntervalSinceNow
        }
        return total
    }

}
