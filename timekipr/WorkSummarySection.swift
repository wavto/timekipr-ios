//
//  WorkSummarySection.swift
//  timekipr
//
//  Created by dave on 01.02.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation

class WorkSummarySection {
    
    var name: NSString
    var timeEntries: [TimeEntry] = [TimeEntry]()
    
    init(name: NSString) {
        self.name = name
    }
    
    func getSectionTotalTime() -> NSString {
        var time: Double = 0
        for entry in self.timeEntries {
            time += entry.getTotalTime(showTotalForCurrentTime: false)
        }
        return Helper.getFormattedTimeTotal(time, showSeconds: false)
    }
}