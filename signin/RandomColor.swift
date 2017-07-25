//
//  RandomColor.swift
//  signin
//
//  Created by Shannon Ding on 7/24/17.
//  Copyright © 2017 Shannon Ding. All rights reserved.
//

import Foundation
import UIKit

struct RandomColor {

        static var colors: [UIColor] = []
        static let pink = UIColor(red:1.00, green:0.18, blue:0.33, alpha:1.0)
        static let red = UIColor(red:1.00, green:0.23, blue:0.19, alpha:1.0)
        static let orange = UIColor(red:1.00, green:0.58, blue:0.00, alpha:1.0)
        static let yellow = UIColor(red:1.00, green:0.80, blue:0.00, alpha:1.0)
        static let green = UIColor(red:0.30, green:0.85, blue:0.39, alpha:1.0)
        static let lightBlue = UIColor(red:0.35, green:0.78, blue:0.98, alpha:1.0)
        static let blue = UIColor(red:0.20, green:0.67, blue:0.86, alpha:1.0)
        static let darkBlue = UIColor(red:0.00, green:0.48, blue:1.00, alpha:1.0)
        static let purple = UIColor(red:0.35, green:0.34, blue:0.84, alpha:1.0)
    
    
    static func chooseColor() -> UIColor {
        RandomColor.colors = [self.pink, self.red, self.orange, self.yellow, self.green, self.lightBlue, self.blue, self.darkBlue, self.purple]
        let randomIndex = Int(arc4random_uniform(UInt32(RandomColor.colors.count)))
        return RandomColor.colors[randomIndex]
    }
    
}
