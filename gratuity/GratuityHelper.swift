//
//  GratuityHelper.swift
//  gratuity
//
//  Created by emersonmalca on 9/25/16.
//  Copyright © 2016 Emerson Malca. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    public static let DefaultGratuityDidChange = Notification.Name(rawValue: "DefaultGratuityDidChangeNotification")
}

class GratuityHelper: NSObject {
    
    static let tipOptions = [0.15, 0.18, 0.2]
    private static let defaultTipKey = "DefaultTipKey"
    
    class var defaultTip : Double {
        
        get {
            let tip = UserDefaults.standard.double(forKey: GratuityHelper.defaultTipKey)
            return tip > 0.0 ? tip : 0.18
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: GratuityHelper.defaultTipKey)
            
            // Tell the world
            NotificationCenter.default.post(name: .DefaultGratuityDidChange, object: nil)
        }
        
    }
    
    class func defaultTipIndex() -> Int {
        if let index = tipOptions.index(of: defaultTip) {
            return index
        }
        
        // If for some reason we couldn't find the default tip in the tip options
        // we just return the tip right in the middle
        return Int(floor(Double(tipOptions.count)/2.0))
    }
    
}
