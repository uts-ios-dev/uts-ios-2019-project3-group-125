//
//  UIStoryboard+Ext.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit


public extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }
    
    static var sign: UIStoryboard {
        return UIStoryboard(name: "Sign", bundle: nil)
    }
    
    static var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }

    struct Scene {
        static var home: IndexViewController {
            return UIStoryboard.main.instantiateVC(IndexViewController.self)!
        }
        
        static var index: IndexViewController {
            return UIStoryboard.main.instantiateVC(IndexViewController.self)!
        }
        
        static var mine: ProfileViewController {
            return UIStoryboard.main.instantiateVC(ProfileViewController.self)!
        }

        // MARK: - 签到
        /// 签到缺席人员
        static var camera: CameraViewController {
            return UIStoryboard.sign.instantiateVC(CameraViewController.self)!
        }

        static var signIn: Sign_InfoViewController {
            return UIStoryboard.sign.instantiateVC(Sign_InfoViewController.self)!
        }


        // MARK: - Setting

        static var login: LoginViewController {
            return UIStoryboard.login.instantiateVC(LoginViewController.self)!
        }

        /// 设置密码
        static var bindPwd: BindPwdViewController {
            return UIStoryboard.login.instantiateVC(BindPwdViewController.self)!
        }
 
    }
}
