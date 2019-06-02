//
//  Student.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

/// 学生
class Student: Object {
    @objc dynamic var user_id: String = ""      // 百度人脸ID  对应 学号
    @objc dynamic var name: String = ""
    @objc dynamic var sex: String = ""
    @objc dynamic var subject: Subject?
    @objc dynamic var grade: String = ""        //年级
    
    @objc dynamic var face: String = ""         //本地存储图片路径
    @objc dynamic var face_token: String = ""   // 百度人脸编码
    
    override static func primaryKey() -> String? {
        return "user_id"
    }
//    
//    /// 额外的参数，标记
//    var signInImage: String?
    
}

func == (lhs: Student, rhs:Student) -> Bool {
    return lhs.name == rhs.name && lhs.user_id == rhs.user_id  && lhs.subject == rhs.subject
}

extension Student {
    static func add(_ name: String, sex: String, user_id: String, subject: Subject, grade: String, face: String, face_token: String) {
        let goods = Student()
        goods.name = name
        goods.sex = sex
        goods.user_id = user_id
        goods.subject = subject
        goods.grade = grade
        goods.face = face
        goods.face_token = face_token
        
        var exsit = false
        for go in Student.getAllStudent() {
            if go == goods {
                exsit = true
                break
            }
        }
        
        if !exsit {
            goods.writeToDB()
        }
    }
    
    func writeToDB() {
        // Realms are used to group data together
        let realm = try! Realm() // Create realm pointing to default file
        
        // Persist your data easily
        try! realm.write {
            realm.add(self)
        }
        
    }
    
    func delete() {
        let realm = try! Realm() // Create realm pointing to default file
        
        // Persist your data easily
        try! realm.write {
            realm.delete(self)
        }
        
    }
    
    func deleteBy(_ user: String) {
        let cos = Student.getAllStudent()
        cos.forEach {
            if $0.name == user  {
                $0.delete()
            }
        }
    }
    
    /// 根据用户名和quote 找到 是否有like
    static func getStudentBy(_ user: String) -> Student? {
        let cos = Student.getAllStudent()
        var retCo : Student?
        cos.forEach {
            if $0.name == user  {
                retCo = $0
            }
        }
        
        return retCo
        
    }
    
    /// 获取某一班的数据   name : 操作系统1班
    static func getStudentBySubject(_ name: String) -> [Student] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Student.self).sorted(byKeyPath: "user_id", ascending: true).filter("subject.classerName = '\(name)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [Student]
    }
    
    static func getStudentById(_ id: String) -> Student? {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Student.self).sorted(byKeyPath: "user_id", ascending: true).filter("user_id = '\(id)'")
        let array = results.get(offset: 0, limit: results.count)
        if array.count > 0 {
            return array[0] as? Student
        } else {
            return nil
        }
    }
    
    static func getAllStudent() -> [Student] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Student.self).sorted(byKeyPath: "user_id", ascending: true)
        let array = results.get(offset: 0, limit: results.count)
        return array as! [Student]
    }
    
    static func getAllStudentBySubject(_ subj: String) -> [Student] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Student.self).sorted(byKeyPath: "user_id", ascending: true).filter("subject.name = '\(subj)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [Student]
    }
}
