//
//  LoginViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit

class LoginViewController: MTBaseViewController {

    @IBOutlet weak var smsLoginView: UIView!
    
    @IBOutlet weak var mobileNoField: UITextField!
    
    @IBOutlet weak var pwdField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        
        #if DEBUG
            mobileNoField.text = "2019001"
            pwdField.text = "2019001"
        #endif

        view.addTapToCloseEditing()
        
        mobileNoField.becomeFirstResponder()
    }

    @IBAction func colse() {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func register() {
        let vc = self.storyboard?.instantiateVC(BindPwdViewController.self)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func login() {
        loginWithAccount()
    }
    

    private func loginWithAccount() {
        guard let text = mobileNoField.text, text.count > 0 else {
            return showMessage("Please enter user name")
        }

        guard let password = pwdField.text, password.count > 0 else {
            return showMessage("Please enter password")
        }
        
        view.endEditing(true)
        
        
        Plist.array(.teacher, success: { (ts) in
            let filter = ts.filter({text == $0["username"] as! String && password == $0["password"] as! String})
            if filter.count > 0 {
                User.shared.bind(filter[0])
                AppDelegate.shared.loginSuccess()
            }
        }) { (err) in
            showMessage(err.localizedDescription)
        }
    }
    

}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mobileNoField {
            pwdField.becomeFirstResponder()
        }
        if textField == pwdField {
            login()
        }

        return true
    }

}
