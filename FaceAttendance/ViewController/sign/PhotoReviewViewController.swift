//
//  PhotoReviewViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit
import EasyPeasy

class PhotoReviewViewController: MTBaseViewController {

    /// 录入人脸时传入
    var student: JSONMap = [:]
    private var image: UIImage
    
    
    /// 考勤的时候 传入， 便于搜索人脸
    var group: String?
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(image: UIImage, group: String) {
        self.image = image
        self.group = group
        super.init(nibName: nil, bundle: nil)
    }
    
    init(image: UIImage, student: JSONMap) {
        self.image = image
        self.student = student
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.contentMode = UIView.ContentMode.scaleAspectFit
        backgroundImageView.image = image
        view.addSubview(backgroundImageView)
        
        
        
        let okButton = UIButton(type: .custom)
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        okButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        okButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        okButton.backgroundColor = MTColor.main.alpha(0.8)
        view.addSubview(okButton)
        okButton.easy.layout(Right(0), Width(UIScreen.main.bounds.width / 2), Height(50), Bottom(55).to(self.view.safeAreaLayoutGuide, .bottom))
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.setTitle("Retake", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        cancelButton.backgroundColor = MTColor.main.alpha(0.8)
        view.addSubview(cancelButton)
        cancelButton.easy.layout(Right(0).to(okButton), Left(0), Height(50), CenterY(0).to(okButton))

    }
    
    @objc func submit() {
        if let gr = group?.replace(" ", withString: "") {
            search(gr)
        } else {
            upload()
        }
    }
    
    private func search(_ groupName: String) {
        let img = image.scaleToMinSideLength(100)
        MTHUD.showLoading()
        HttpApi.searchUser(img, group: groupName, completion: { (json) in
            
            if let user_list = json["user_list"] as? [JSONMap], user_list.count > 0, let user_id = user_list[0]["user_id"] as? String {
                
                if let stu = Student.getStudentById(user_id) {
                    /// 检查是否已经签到
                    if !SignIn.haveSignIned(Date().toString("yyyy-MM-dd"), student: stu) {
                        /// 存入图片
                        let path = img.saveToDoc()
                        SignIn.saveSignIn(stu, image: path)
                        
                        MTHUD.showToaster(.success, message: stu.name + " Sign-in success", delay: 2.5)
                        self.navigationController?.popViewController(animated: true)
                        
                        return
                    }
                }
                MTHUD.showToaster(.error, message: "Recognition failed, please click retake", delay: 2)
                
            }
        }) { (err) in
            //MTHUD.hide()
            MTHUD.showToaster(.error, message: "Recognition failed, please click retake", delay: 2)
            //showMessage(err)
        }
    }
    
    private func upload() {
        guard let gr = student["classer"] as? String , let userId = student["no"] as? Int else {return }
        let img = image.scaleToMinSideLength(100)
        MTHUD.showLoading()
        HttpApi.addUser(img, group: gr.replace(" ", withString: ""), userId: String(userId), completion: { (json) in
            //MTHUD.hide()
            MTHUD.showToaster(.success, message: "Successfully saved")
            
            var path = ""
            if let loc = json["location"] as? JSONMap , let left = loc["left"] as? CGFloat,
                let top = loc["top"] as? CGFloat, let width = loc["width"] as? CGFloat, let height = loc["height"] as? CGFloat {
                
                let rect = CGRect(x: max(left - 10, 0), y: max(top - 10, 0),
                                  width: min(img.size.width, width + 20) ,
                                  height: min(img.size.height, height + 20))
                path = img.cropped(to: rect).saveToDoc()
            } else {
                path = img.saveToDoc()
            }
            
            let name = self.student["name"] as! String
            let sex = self.student["sex"] as! String
            let grade = self.student["grade"] as! String
            
            Student.add(name, sex: sex, user_id: String(userId), subject: Subject.getAllSubjectByClasserName(gr)[0],
                        grade: grade, face: path, face_token: json["face_token"] as! String)
            
            
            self.navigationController?.dismiss(animated: true, completion: nil)
        }) { (err) in
            MTHUD.hide()
            showMessage(err)
        }
    }
    
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
