//
//  User.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation


let kUserInfo = "loginedUser"

public class User {
    private static let _sharedInstance = User()
    
    public static var shared: User {
        return _sharedInstance
    }

    
    var access_token: String = ""
    
    /// 姓名
    var name: String = ""

    var userName: String?  /// 用户名
    
    /// 登录成功
    func bind(_ source: JSONMap) {
        
        if let userName = source["username"] as? String {
            self.userName = userName
        }
        if let name = source["name"] as? String {
            self.name = name
        }

        UserDefaults.standard.set(source, forKey: kUserInfo)
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: kUserInfo)
        User.shared.name = ""
        User.shared.userName = nil
    }

    
    static var isLogined: Bool {
        if let user :JSONMap = UserDefaults.standard.dictionary(forKey: kUserInfo) {
            if let userName = user["username"] as? String {
                User.shared.userName = userName
            }
            User.shared.bind(user)
            return true
        }
        return false
    }
}
