//
//  config.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import  UIKit


public typealias JSONMap = [String: Any]

struct AppConfig {
    static let backImage = CAShapeLayer.backShape(edgeLength: 16).toImage()
}

struct MTColor {
    static var main = UIColor(red:0.87, green:0.31, blue:0.26, alpha:1.00)

    static var pageback = UIColor.white
    
    static var title111 = UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00)
    static var title222 = UIColor(hex: 0x222222)
    
    static var des666 = UIColor(hex: 0x666666)
}


// status bar height.
let kStatusBarHeight: CGFloat = (UIDevice.isIPhoneXSeries ? 44.0 : 20.0)

// Navigation bar height.
let  kNavigationBarHeight: CGFloat = 44.0

// Tabbar height.
let kTabbarHeight: CGFloat = (UIDevice.isIPhoneXSeries ? (49.0 + 34.0) : 49.0)

// Tabbar safe bottom margin.
let kTabbarSafeBottomMargin: CGFloat = (UIDevice.isIPhoneXSeries ? 34.0 : 0.0)

// Status bar & navigation bar height.
let kStatusBarAndNavigationBarHeight: CGFloat = (UIDevice.isIPhoneXSeries ? 88.0 : 64.0)
