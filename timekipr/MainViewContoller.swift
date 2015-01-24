//
//  MainViewContoller.swift
//  timekipr
//
//  Created by dave on 02.12.14.
//  Copyright (c) 2014 dave.onl. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainViewController: UITableViewController, UITableViewDataSource {
    
    var projects = [Project]()
    lazy var managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    
    @IBAction func unwindToSegueFromAddProject(segue: UIStoryboardSegue) {
        var source: AddProjectViewController = segue.sourceViewController as AddProjectViewController
        if (source.projectName == nil || source.projectColorName == nil) {
            //TODO handle error
            return
        }
        if let project = source.project {
            project.name = source.projectName!
            project.color = source.projectColorName!
        } else {
            let project = Project.create(source.projectName!, projectColor: source.projectColorName!, insertIntoManagedObjectContext: self.managedObjectContext!)
            self.projects.append(project)
        }
        self.tableView.reloadData()
    }
    
    @IBAction func unwindToSegueWithoutAction(segue: UIStoryboardSegue) {
        
    }
    
    
    func initProjects() {
        let fetchRequest = NSFetchRequest(entityName: "Project")
        let sortDescriptor = NSSortDescriptor(key: "Name", ascending: true)
        fetchRequest.sortDescriptors?.append(sortDescriptor)
        if let fetchResults = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Project] {
            self.projects = fetchResults
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.projects[indexPath.row].name
        cell.backgroundColor = {
            for color in Helper.getColorTuples() {
                if (color.name == self.projects[indexPath.row].color) {
                    return color.color
                }
            }
            return Helper.getColorTuples()[0].color
        }()
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject] {
        var editAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "edit", handler: {(action, indexPath: NSIndexPath!) -> Void in
            tableView.editing = false
            self.performSegueWithIdentifier("editProject", sender: self.projects[indexPath.row])
        })
        editAction.backgroundColor = UIColor.blueColor()
        
        var deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "delete", handler: {(action, indexPath) -> Void in
            tableView.editing = false
            self.managedObjectContext!.deleteObject(self.projects[indexPath.row])
            self.projects.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        })
        deleteAction.backgroundColor = UIColor.redColor()
        
        return [deleteAction, editAction]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("startTimer", sender: self.projects[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as UINavigationController
        if (segue.identifier == "editProject") {
            let addProjectViewController = navigationController.viewControllers.first as? AddProjectViewController
            addProjectViewController?.project = sender as? Project
        }
        if (segue.identifier == "startTimer") {
            let timeEntryViewController = navigationController.viewControllers.first as? TimeEntryViewController
            if let project = sender as? Project {
                timeEntryViewController?.timeEntry = TimeEntry.create(NSDate(), timeEntryProject: project, insertIntoManagedObjectContext: self.managedObjectContext!)
            }
        }
    }
    
    private func findProjectFromName(name: NSString) -> Project? {
        for project in self.projects {
            if (project.name == name) {
                return project
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initProjects()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}