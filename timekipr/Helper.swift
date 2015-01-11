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
            ("White", UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(255/255.0), alpha: 1.0)),
            ("Red", UIColor(red: CGFloat(255/255.0), green: CGFloat(0/255.0), blue: CGFloat(0/255.0), alpha: 1.0)),
            ("Lime", UIColor(red: CGFloat(0/255.0), green: CGFloat(255/255.0), blue: CGFloat(0/255.0), alpha: 1.0)),
            ("Blue", UIColor(red: CGFloat(0/255.0), green: CGFloat(0/255.0), blue: CGFloat(255/255.0), alpha: 1.0)),
            ("Yellow", UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(0/255.0), alpha: 1.0)),
            ("Cyan / Aqua", UIColor(red: CGFloat(0/255.0), green: CGFloat(255/255.0), blue: CGFloat(255/255.0), alpha: 1.0)),
            ("Magenta / Fuchsia", UIColor(red: CGFloat(255/255.0), green: CGFloat(0/255.0), blue: CGFloat(255/255.0), alpha: 1.0)),
            ("Silver", UIColor(red: CGFloat(192/255.0), green: CGFloat(192/255.0), blue: CGFloat(192/255.0), alpha: 1.0)),
            ("Gray", UIColor(red: CGFloat(128/255.0), green: CGFloat(128/255.0), blue: CGFloat(128/255.0), alpha: 1.0)),
            ("Maroon", UIColor(red: CGFloat(128/255.0), green: CGFloat(0/255.0), blue: CGFloat(0/255.0), alpha: 1.0)),
            ("Olive", UIColor(red: CGFloat(128/255.0), green: CGFloat(128/255.0), blue: CGFloat(0/255.0), alpha: 1.0)),
            ("Green", UIColor(red: CGFloat(0/255.0), green: CGFloat(128/255.0), blue: CGFloat(0/255.0), alpha: 1.0)),
            ("Purple", UIColor(red: CGFloat(128/255.0), green: CGFloat(0/255.0), blue: CGFloat(128/255.0), alpha: 1.0)),
            ("Teal", UIColor(red: CGFloat(0/255.0), green: CGFloat(128/255.0), blue: CGFloat(128/255.0), alpha: 1.0)),
            ("Navy", UIColor(red: CGFloat(0/255.0), green: CGFloat(0/255.0), blue: CGFloat(128/255.0), alpha: 1.0))
        ]
    }
}
