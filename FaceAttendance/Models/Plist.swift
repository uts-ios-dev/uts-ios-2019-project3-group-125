//
//  Plist.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation

struct Plist {
    enum PlistName: String {
        case teacher = "Teachers"
        case student = "Students"
        case sub = "Subs"
    }
    
    static func dictionary(_ name : PlistName, success: ([String: Any])->(), error : (Error)->()) {
        guard let filepath = Bundle.main.path(forResource: name.rawValue, ofType: "plist") else {
            error(PListParserErrors.couldNotFindPList)
            return
        }
        guard let plist = NSDictionary(contentsOfFile: filepath) as? [String: Any] else {
            error(PListParserErrors.couldNotParsePlist)
            return
        }
        success(plist)
    }
    
    static func array(_ name : PlistName, success: ([[String: Any]])->(), error : (Error)->()) {
        guard let filepath = Bundle.main.path(forResource: name.rawValue, ofType: "plist") else {
            error(PListParserErrors.couldNotFindPList)
            return
        }
        guard let plist = NSArray(contentsOfFile: filepath) as? [[String: Any]] else {
            error(PListParserErrors.couldNotParsePlist)
            return
        }
        success(plist)
    }
}


enum PListParserErrors : Error {
    case couldNotFindPList
    case couldNotParsePlist
}
