//
//  AddProjectViewController.swift
//  timekipr
//
//  Created by dave on 11.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import UIKit


class AddProjectViewController: UIViewController {
    
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectColorField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var projectName: NSString?
    var projectColor: NSString?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIBarButtonItem != self.saveButton) {
            return
        }
        self.projectName = self.projectNameField.text
        self.projectColor = self.projectNameField.text
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
