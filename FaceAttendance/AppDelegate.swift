//
//  AppDelegate.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit
import CoreGraphics
import WebKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window!.frame  = CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width + 0.01, height: UIScreen.main.bounds.height + 0.01)
        window!.backgroundColor = UIColor.white

        
        UITextField.appearance().tintColor = MTColor.main
        UITextView.appearance().tintColor = MTColor.main
        
        /// 检测默认课程数据
        Subject.loadDefaultData()
        
        if User.isLogined {
            loginSuccess()
        } else {
            signout()
        }
        
        
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func loginSuccess() {
        HttpApi.getAuth({ (token) in
            User.shared.access_token = token
        }) { (_) in
        }
        self.window?.rootViewController = MTNavigationController(rootViewController: UIStoryboard.Scene.index)
    }
    
    func signout() {
        User.logout()
        
        let vc = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateVC(LoginViewController.self)!
        self.window?.rootViewController = MTNavigationController(rootViewController: vc)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}


