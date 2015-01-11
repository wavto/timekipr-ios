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
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else {
            return nil
        }
    }()
    
    @IBAction func unwindToSegueFromAddProject(segue: UIStoryboardSegue) {
        var source: AddProjectViewController = segue.sourceViewController as AddProjectViewController
        if let projectName = source.projectName {
            let project = Project.create(projectName, projectColor: source.projectColor, insertIntoManagedObjectContext: self.managedObjectContext!)
            self.projects.append(project)
            self.tableView.reloadData()
        }
    }
    
    
    func initProjects() {
        let fetchRequest = NSFetchRequest(entityName: "Project")
        let sortDescriptor = NSSortDescriptor(key: "Name", ascending: true)
        fetchRequest.sortDescriptors?.append(sortDescriptor)
        if let fetchResults = self.managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Project] {
            self.projects = fetchResults
        }
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("projectCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = self.projects[indexPath.row].name
        return cell
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