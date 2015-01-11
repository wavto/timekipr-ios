//
//  WorkSummaryViewController.swift
//  timekipr
//
//  Created by dave on 11.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import UIKit

class WorkSummaryViewController: UITableViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("summaryCell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
