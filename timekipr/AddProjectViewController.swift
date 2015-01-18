//
//  AddProjectViewController.swift
//  timekipr
//
//  Created by dave on 11.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import UIKit


class AddProjectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectColorPicker: UIPickerView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var projectName: NSString?
    var projectColorName: NSString?
    var colors: [(name: NSString, color: UIColor)] = []
    var project: Project?
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (sender as? UIBarButtonItem != self.saveButton) {
            return
        }
        self.projectName = self.projectNameField.text
        self.projectColorName = self.colors[self.projectColorPicker.selectedRowInComponent(0)].name
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.projectNameField.endEditing(true)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.projectNameField.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.colors.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as UILabel!
        if (view == nil) {
            pickerLabel = UILabel()
            pickerLabel.backgroundColor = self.colors[row].color
        }
        pickerLabel.attributedText = NSAttributedString(string: self.colors[row].name)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initColors()
        if let project = self.project {
            self.title = "edit project"
            self.projectNameField.text = project.name
            self.projectColorPicker.selectRow(Helper.getIndexFromName(project.color)!, inComponent: 0, animated: false)
        }
        self.projectNameField.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initColors() {
        self.colors += Helper.getColorTuples()
    }
    
}
