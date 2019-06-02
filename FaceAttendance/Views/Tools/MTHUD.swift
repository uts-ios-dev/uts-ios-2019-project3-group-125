//
//  MTHUD.swift
//  MovelRater
//
//  Created by Jerry on 2019/4/20.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import Foundation

import UIKit



struct MTHUD {
    enum ToasterStatus {
        case success, error, message
    }
    
    
    static func showToaster(_ status: ToasterStatus, message: String? = nil, delay: Double = 2, handle: (()->())? = nil) {
        KRProgressHUD.set(deadlineTime: delay)
        KRProgressHUD.set(style: .black)
        KRProgressHUD.set(viewOffset: -40)
        switch status {
        case .success:
            KRProgressHUD.showImage(#imageLiteral(resourceName: "toast_success"), message:  message)
        case .error:
            KRProgressHUD.showImage(#imageLiteral(resourceName: "toast_error"), message:  message)
        case .message:
            KRProgressHUD.showMessage(message ?? "")
        }
    }
    
    static func showLoading() {
        KRProgressHUD.set(viewOffset: -40)
        KRProgressHUD.set(style: .black)
        KRProgressHUD.shared.show(withMessage: "加载中...", isLoading: true, completion: nil)
    }
    
    static func hide(_ completion: (() -> Void)? = nil)  {
        KRProgressHUD.dismiss {
            completion?()
        }
    }
    
    
}
