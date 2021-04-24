//
//  UIColor+Extensions.swift
//  TimingKit
//
//  Created by Zulwiyoza Putra on 24/04/21.
//

import UIKit


public extension UIColor {
    static var defaultTintColor: UIColor {
        return .darkGreen
    }
    
    static private var darkGreen: UIColor {
        return UIColor(red: 45/255, green: 156/255, blue: 92/255, alpha: 1.0)
    }
}
