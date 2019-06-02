//
//  AppDelegate+Ext.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import UIKit



extension AppDelegate {
    
    static var shared: AppDelegate {
        get {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                return appDelegate
            }
            return AppDelegate()
        }
    }

    static var root: UIViewController  {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.window!.rootViewController!
        }
    }
    
}



public extension UIApplication {
    static var cachesDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }
    
    static var supportDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first!
    }
    
    static var documentsDirectory: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }
}
