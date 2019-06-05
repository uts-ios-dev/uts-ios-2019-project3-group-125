//
//  BaiduFace.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

let authUrl = "https://aip.baidubce.com/oauth/2.0/token"
let addUserUrl = "https://aip.baidubce.com/rest/2.0/face/v3/faceset/user/add"

let searchUserUrl = "https://aip.baidubce.com/rest/2.0/face/v3/search"

struct HttpApi {
    static func getAuth(_ completion: @escaping ((_ auth: String)->()) , failed:  @escaping ((_ error: String)->())) {
        //let manager = SessionManager.default
        //manager.session.configuration.timeoutIntervalForRequest = 120
        
        AF.request(authUrl, method: .post, parameters: ["grant_type":"client_credentials", "client_id":"nNy7DtsRGls22sSq1ToXkiST", "client_secret":"DUPqg7DREdf6G36v6jcEEvQBvRw0utpH"])
            .responseJSON {
                response in
                switch response.result {
                case .success(let value):
                    if let json = value as? JSONMap, let access_token = json["access_token"] as? String {
                        User.shared.access_token = access_token
                        completion(access_token)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
        }
    }
    
    
    /// 注册人脸
    ///
    /// ```
    /// "result": {
    ///     "face_token": "a08cf9e61cd82b7c8f8810dddb05b45b",
    ///     "location": {
    ///         "left": 139.73,
    ///         "top": 163.01,
    ///         "width": 57,
    ///         "height": 46,
    ///         "rotation": -16
    ///     }
    /// }
    /// ```
    /// - Parameters:
    ///   - image: 图片
    ///   - group: 组  班级
    ///   - userId: 用户ID  学生编号
    ///   - completion:
    ///   - failed:
    static func addUser(_ image: UIImage, group: String, userId: String, completion: @escaping ((_ result: JSONMap)->()),
                        failed:  @escaping ((_ error: String)->()) ) {
        //let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let headers: HTTPHeaders = [.contentType("application/x-www-form-urlencoded")]
        let parameters = [
            "image": image.toBase64()!,
            "access_token": User.shared.access_token,
            "image_type": "BASE64",
            "group_id": group,
            "user_id": userId
        ]
        
        //let manager = SessionManager.default
        //manager.session.configuration.timeoutIntervalForRequest = 120
        AF.request(addUserUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            print("-----------------> \n")
            print(response.result)
            switch (response.result) {
            case .success(let value):
                guard let json = value as? JSONMap else {
                    failed("")
                    return
                }
                guard let error_code = json["error_code"] as? Int, error_code == 0 else  {
                    failed(json["error_msg"] as! String)
                    return
                }
                
                if let result = json["result"] as? JSONMap {
                    completion(result)
                } else {
                    failed("")
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    print("Request timeout!")
                }
                failed(error.localizedDescription)
            }
        }
    }
    
    
    /// 搜索FACE
    ///
    /// ```
    ///    "face_token": "a08cf9e61cd82b7c8f8810dddb05b45b",
    ///    "user_list": [
    ///         {
    ///             "group_id": "cz1",
    ///             "user_id": "1",
    ///             "user_info": "",
    ///             "score": 93.423439025879
    ///         }
    ///     ]
    /// ```
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - group: 组
    ///   - completion: 完成
    ///   - failed: 失败
    static func searchUser(_ image: UIImage, group: String, completion: @escaping ((_ result: JSONMap)->()),
                        failed:  @escaping ((_ error: String)->()) ) {
        let headers: HTTPHeaders = [.contentType("application/x-www-form-urlencoded")]
        let parameters = [
            "image": image.toBase64()!,
            "access_token": User.shared.access_token,
            "image_type": "BASE64",
            "group_id_list": group
        ]
        
        //let manager = SessionManager.default
        //manager.session.configuration.timeoutIntervalForRequest = 120
        AF.request(searchUserUrl, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            print("-----------------> \n")
            print(response.result)
            switch (response.result) {
            case .success(let value):
                guard let json = value as? JSONMap else {
                    failed("")
                    return
                }
                guard let error_code = json["error_code"] as? Int, error_code == 0 else  {
                    failed(json["error_msg"] as! String)
                    return
                }
                
                if let result = json["result"] as? JSONMap {
                    completion(result)
                } else {
                    failed("")
                }
            case .failure(let error):
                if error._code == NSURLErrorTimedOut {
                    print("Request timeout!")
                }
                failed(error.localizedDescription)
            }
        }
    }
    
}
