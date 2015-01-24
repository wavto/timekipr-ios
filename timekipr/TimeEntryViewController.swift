//
//  TimeEntryViewController.swift
//  timekipr
//
//  Created by dave on 02.12.14.
//  Copyright (c) 2014 dave.onl. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TimeEntryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeNameLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var projectPicker: UIPickerView!
    @IBOutlet weak var summaryBarButton: UIBarButtonItem!
    
    var timeEntry: TimeEntry?
    var editingStartTime: Bool?
    var projectList = [Project]()
    lazy var managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
    
    
    @IBAction func showTimeDatePicker(sender: UITapGestureRecognizer) {
        let isStartTime = sender.view == self.startTimeLabel
        let isHidden = self.timeDatePicker.hidden || self.editingStartTime == !isStartTime
        self.hideEditElement(sender)
        if isHidden {
            self.editingStartTime = isStartTime
            if let time = isStartTime ? self.timeEntry?.start : self.timeEntry?.end {
                self.timeDatePicker.setDate(time, animated: false)
            }
            if isStartTime {
                self.timeDatePicker.maximumDate = (self.timeEntry?.end != nil) ? self.timeEntry!.end : NSDate()
            } else {
                self.timeDatePicker.minimumDate = self.timeEntry!.start
            }
            self.timeDatePicker.hidden = false
        }

    }
    
    @IBAction func showProjectPicker(sender: UITapGestureRecognizer) {
        let isHidden = self.projectPicker.hidden
        self.hideEditElement(sender)
        if isHidden {
            if let timeEntry = self.timeEntry {
                self.projectPicker.selectRow(find(self.projectList, timeEntry.timeEntryProject)!, inComponent: 0, animated: false)
            }
            self.projectPicker.hidden = false
        }
    }
    
    @IBAction func hideEditElement(sender: UITapGestureRecognizer) {
        self.timeDatePicker.hidden = true
        self.timeDatePicker.minimumDate = nil
        self.timeDatePicker.maximumDate = nil
        self.editingStartTime = nil
        self.projectPicker.hidden = true
    }
    
    private func initView() {
        self.setStartTime()
        self.setEndTime()
        self.setCurrentProject()
        self.initTimer()
        self.initEditView()
    }
    
    private func initEditView() {
        self.addTapGestureRecognizerToLabel("hideEditElement:", viewElement: self.view)
        self.addTapGestureRecognizerToLabel("showProjectPicker:", viewElement: self.projectLabel)
        self.addTapGestureRecognizerToLabel("showTimeDatePicker:", viewElement: self.startTimeLabel)
        self.addTapGestureRecognizerToLabel("showTimeDatePicker:", viewElement: self.endTimeLabel)
        self.initProjectList()
    }
    
    private func initTimer() {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer:"), userInfo: nil, repeats: true)
    }
    
    @IBAction func updateTimer(sender: AnyObject) {
        if let startTime = self.timeEntry?.start {
            let timeIntervall = self.timeEntry?.end != nil ? -startTime.timeIntervalSinceDate(self.timeEntry!.end) : -startTime.timeIntervalSinceNow
            let hours = Int(timeIntervall / 3600)
            let minutes = Int((timeIntervall % 3600) / 60)
            let seconds = Int((timeIntervall % 3600) % 60)
            let formatter = NSNumberFormatter()
            formatter.minimumIntegerDigits = 2
            let time = formatter.stringFromNumber(hours)! + ":" + formatter.stringFromNumber(minutes)! + ":" +
                formatter.stringFromNumber(seconds)!
            self.timerLabel.text = time
        }
    }
    
    @IBAction func timeDateChanged(datePicker: UIDatePicker) {
        if (self.editingStartTime!) {
            timeEntry?.start = datePicker.date
            self.setStartTime()
        } else {
            timeEntry?.end = datePicker.date
            self.setEndTime()
        }
        self.updateTimer(datePicker)
    }

    @IBAction func stopButtonClicked(button: UIButton) {
        //self.summaryBarButton
        self.navigationController?.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector("segueBackToMain:")), animated: false)
        self.timeEntry!.end = NSDate()
        self.setEndTime()
    }
    
    @IBAction func segueBackToMain(sender: AnyObject?) {
        self.performSegueWithIdentifier("backToMain", sender: sender)
    }
    
    private func setCurrentProject() {
        self.projectLabel.text = self.timeEntry?.timeEntryProject.name
        if let colorName = self.timeEntry?.timeEntryProject.color {
            self.projectLabel.backgroundColor = Helper.getColorFromName(colorName)
        }
    }
    
    private func setStartTime() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        if let timeEntry = self.timeEntry {
            self.startTimeLabel.text = dateFormatter.stringFromDate(timeEntry.start)
        }
    }

    private func setEndTime() {
        if let endTime = self.timeEntry?.end {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            self.endTimeLabel.text = dateFormatter.stringFromDate(endTime)
            self.endTimeNameLabel.hidden = false
            self.endTimeLabel.hidden = false
            self.stopButton.hidden = true
        } else {
            self.endTimeNameLabel.hidden = true
            self.endTimeLabel.hidden = true
        }
    }
    
    private func initProjectList() {
        let fetchRequest = NSFetchRequest(entityName: "Project")
        fetchRequest.sortDescriptors?.append(NSSortDescriptor(key: "Name", ascending: true))
        if let fetchResults = self.managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as? [Project] {
            self.projectList = fetchResults
        }
    }
    
    private func addTapGestureRecognizerToLabel(selector: NSString, viewElement: UIView) -> Void {
        viewElement.userInteractionEnabled = true
        viewElement.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector(selector)))
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let entry = self.timeEntry {
            entry.timeEntryProject = self.projectList[row]
        }
        self.setCurrentProject()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.projectList.count
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = view as UILabel!
        if (view == nil) {
            pickerLabel = UILabel()
            pickerLabel.backgroundColor = Helper.getColorFromName(self.projectList[row].color)
        }
        pickerLabel.attributedText = NSAttributedString(string: self.projectList[row].name)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

