//
//  UIColorExtension.swift
//  SleepSciTest
//
//  Created by Alexander Kudlak on 11/13/18.
//  Copyright © 2018 Alexandr Kudlak. All rights reserved.
//

import UIKit

extension UIColor {
    
    @nonobjc class var customAqua: UIColor {
        return UIColor(red:0.17, green:1.00, blue:1.00, alpha:1.00)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) { cString.removeFirst() }
        
        if ((cString.count) != 6) {
            self.init(hex: "ff0000") // return red color for wrong hex input
            return
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
}
