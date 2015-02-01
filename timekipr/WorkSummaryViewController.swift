//
//  WorkSummaryViewController.swift
//  timekipr
//
//  Created by dave on 11.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class WorkSummaryViewController: UITableViewController, UITableViewDataSource {
    
    var sectionType = "week"
    var sections = [WorkSummarySection]()
    lazy var managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    @IBOutlet weak var toggleSectionButton: UIBarButtonItem!
    
    @IBAction func toggleSection() {
        switch self.sectionType {
            case "month":
            toggleSectionButton.title = "monthly"
            self.sectionType = "week"
        default: //week
            toggleSectionButton.title = "weekly"
            self.sectionType = "month"
        }
        self.initData()
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].timeEntries.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("headerView") as UITableViewHeaderFooterView
        cell.textLabel.text = self.sections[section].name
        var label = UILabel(frame: CGRectMake(tableView.frame.size.width - 77, 2, 62, 18))
        label.textAlignment = NSTextAlignment.Right
        label.text = self.sections[section].getSectionTotalTime()
        label.textColor = UIColor(red: CGFloat(128/255.0), green: CGFloat(128/255.0), blue: CGFloat(128/255.0), alpha: 1.0)
        cell.addSubview(label)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("summaryCell", forIndexPath: indexPath) as UITableViewCell
        var timeEntry = self.sections[indexPath.section].timeEntries[indexPath.row]
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        cell.textLabel?.text = dateFormatter.stringFromDate(timeEntry.start)
        var projectLabel = UILabel(frame: CGRect(x: self.tableView.frame.size.width/3, y: 12, width: self.tableView.frame.size.width/3, height: 20))
        projectLabel.text = timeEntry.timeEntryProject.name
        projectLabel.backgroundColor = Helper.getColorFromName(timeEntry.timeEntryProject.color)
        projectLabel.textAlignment = NSTextAlignment.Center
        cell.addSubview(projectLabel)
        cell.detailTextLabel?.text = Helper.getFormattedTimeTotal(timeEntry.getTotalTime(showTotalForCurrentTime: false), showSeconds: false)
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showTimeEntry", sender: self.sections[indexPath.section].timeEntries[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showTimeEntry" {
            let navController = segue.destinationViewController as UINavigationController
            var dest = navController.viewControllers.first as TimeEntryViewController
            if let timeEntry = sender as? TimeEntry {
                dest.timeEntry = timeEntry
            }
        }
    }
    
    private func initData() {
        let fetchRequest = NSFetchRequest(entityName: "TimeEntry")
        let sortDescriptor = NSSortDescriptor(key: "start", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        if let fetchResults = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [TimeEntry] {
            if fetchResults.count > 0 {
                self.initData(fetchResults)
            }
        }
    }
    
    private func initData(timeEntries: [TimeEntry]) {
        let cal = NSCalendar.currentCalendar()
        var dateFormatter = NSDateFormatter()
        var calUnitYear, calUnitSection: NSCalendarUnit, sectionTitle: (year: Int, section: Int) -> NSString
        switch self.sectionType {
        case "month":
            calUnitYear = NSCalendarUnit.CalendarUnitYear
            calUnitSection = NSCalendarUnit.CalendarUnitMonth
            sectionTitle = {
                (year, section) in
                dateFormatter.dateFormat = "MMMM yyyy"
                var date = NSDateComponents()
                date.year = year
                date.month = section
                return dateFormatter.stringFromDate(cal.dateFromComponents(date)!)
            }
        default: //week
            calUnitYear = NSCalendarUnit.CalendarUnitYearForWeekOfYear
            calUnitSection = NSCalendarUnit.CalendarUnitWeekOfYear
            sectionTitle = {
                (year, section) in
                dateFormatter.dateFormat = "dd.MM.yy"
                var date = NSDateComponents()
                date.yearForWeekOfYear = year
                date.weekOfYear = section
                var dateBegin = cal.dateFromComponents(date)
                var dateEnd = dateBegin!.dateByAddingTimeInterval(NSTimeInterval(24*60*60*6))
                return "Week \(section), \(dateFormatter.stringFromDate(dateBegin!)) - \(dateFormatter.stringFromDate(dateEnd))"
            }
        }
        var firstYear = cal.component(calUnitYear, fromDate: timeEntries.last!.start)
        var lastYear = cal.component(calUnitYear, fromDate: timeEntries.first!.start)
        var firstSectionUnit = cal.component(calUnitSection, fromDate: timeEntries.last!.start)
        var lastSectionUnit = cal.component(calUnitSection, fromDate: timeEntries.first!.start)
        self.sections.removeAll(keepCapacity: true)
        for year in firstYear...lastYear {
            for section in firstSectionUnit...lastSectionUnit {
                var workSummary = WorkSummarySection(name: sectionTitle(year: year, section: section))
                self.sections.append(workSummary)
                for entry in timeEntries {
                    if cal.component(calUnitYear, fromDate: entry.start) == year && cal.component(calUnitSection, fromDate: entry.start) == section {
                        workSummary.timeEntries.append(entry)
                    }
                }
            }
        }
        self.sections = self.sections.reverse()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerView")
        self.initData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}