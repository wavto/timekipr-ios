//
//  Helper.swift
//  timekipr
//
//  Created by dave on 11.01.15.
//  Copyright (c) 2015 dave.onl. All rights reserved.
//

import Foundation
import UIKit

class Helper {

    class func getColorTuples() -> [(name: NSString, color: UIColor)] {
        return [
            ("Red", self.getUIColor(246, g:150, b:121)),
            ("Orange", self.getUIColor(253, g:198, b:137)),
            ("Yellow", self.getUIColor(255, g:247, b:153)),
            ("Lightgreen", self.getUIColor(196, g:223, b:155)),
            ("Green", self.getUIColor(130, g:202, b:156)),
            ("Cyan", self.getUIColor(109, g:207, b:246)),
            ("Blue", self.getUIColor(131, g:147, b:202)),
            ("Violet", self.getUIColor(161, g:134, b:190)),
            ("Magenta", self.getUIColor(244, g:154, b:193))
        ]
    }
    
    class private func getUIColor(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
    }
    
    class func getColorFromName(name: NSString) -> UIColor? {
        for (index, colorItem) in enumerate(self.getColorTuples()) {
            if (colorItem.name == name) {
                return colorItem.color
            }
        }
        return nil
    }
    
    class func getIndexFromName(name: NSString) -> Int? {
        for (index, colorItem) in enumerate(self.getColorTuples()) {
            if (colorItem.name == name) {
                return index
            }
        }
        return nil
    }
    
    class func getFormattedTimeTotal(timeIntervall: Double, showSeconds sec: Bool) -> NSString {
        let hours = Int(timeIntervall / 3600)
        let minutes = Int((timeIntervall % 3600) / 60)
        let seconds = Int((timeIntervall % 3600) % 60)
        let formatter = NSNumberFormatter()
        formatter.minimumIntegerDigits = 2
        var time = formatter.stringFromNumber(hours)! + ":" + formatter.stringFromNumber(minutes)!
        if sec {
            time += ":" + formatter.stringFromNumber(seconds)!
        }
        return time
    }
}
