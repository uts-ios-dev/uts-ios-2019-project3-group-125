//
//  BindPwdViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit



/// 设置密码
class BindPwdViewController: MTBaseViewController {
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var mobileField: UITextField!
    
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Forget password"
        
        
        addNavigationBarLeftButton(self)
        
        #if DEBUG
        userNameField.text = "2019001"
        nameField.text = "David Chalmers"
        mobileField.text = "15828559565"
        #endif
        
        nameField.delegate = self
        mobileField.delegate = self
        
        
        nameField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        mobileField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        userNameField.becomeFirstResponder()
    }
    
    /// 检测状态
    @objc private func editingChanged() {
        if let name = userNameField.text, name.count > 0, let text = nameField.text,
            text.count > 0 , let confirm = mobileField.text, confirm.count > 0 {
            
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }

    
    @IBAction func login() {
        guard let username = userNameField.text, username.count > 0 else {
            return showMessage("please enter user name")
        }
        guard let text = nameField.text, text.count > 0 else {
            return showMessage("please enter real name")
        }
        guard let m = mobileField.text, m.count > 0 else {
            return showMessage("please enter mobile number")
        }
        
        view.endEditing(true)
        
        
        MTHUD.showLoading()
        Plist.array(.teacher, success: { (list) in
            MTHUD.hide()
            let c = list.filter({
                return $0["name"] as! String == text && $0["no"] as! String == username && $0["mobile"] as! String == m
            })
            if c.count > 0 {
                showMessage( "Your login password is：\n" + (c[0]["password"] as! String), during: 3)
            } else {
                showMessage("The information you entered is incorrect.")
            }
        }, error: { (err) in
            MTHUD.hide()
            showMessage(err.localizedDescription)
        })

    }
}

extension BindPwdViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            mobileField.becomeFirstResponder()
        }
        return true
    }
}
