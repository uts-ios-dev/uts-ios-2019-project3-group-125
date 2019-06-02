//
//  SignIn.swift
//  SignIns Box
//
//  Created by bage on 2018/4/17.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


class SignIn: Object {
    @objc dynamic var createdTime: String = ""
    @objc dynamic var student: Student?
    @objc dynamic var image: String = "" // 考勤人脸照片路径

    override static func primaryKey() -> String? {
        return "createdTime"
    }
    
}


func == (lhs: SignIn, rhs:SignIn) -> Bool
{
    return lhs.createdTime == rhs.createdTime   // && lhs.createdTime == rhs.createdTime
}


extension SignIn {
    @discardableResult
    static func saveSignIn(_  stu: Student, image: String) -> SignIn {
        let item = SignIn()
        item.createdTime = String(Date().toString("yyyy-MM-dd hh:mm:ss:SSS"))
        item.student = stu
        item.image = image
        
        var exsit = false
        for go in SignIn.getAllSignIns() {
            if go == item {
                exsit = true
                break
            }
        }
        
        if !exsit {
            item.writeToDB()
        }
        return item
    }
    
    func update()  {
        let realm = try! Realm() // Create realm pointing to default file
        try! realm.write {
            realm.add(self, update: true)
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
    
    /// 检查学生当天是否已签到
    static func haveSignIned(_ date: String, student: Student) -> Bool {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(SignIn.self).sorted(byKeyPath: "createdTime", ascending: false)
                            .filter("createdTime CONTAINS '\(date)' and student.user_id == '\(student.user_id)'")
        let array = results.get(offset: 0, limit: results.count)
        return array.count > 0
    }
    
    static func getAllSignInsByUser(_ user: String) -> [SignIn] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(SignIn.self).sorted(byKeyPath: "createdTime", ascending: false).filter("student.name == '\(user)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [SignIn]
    }
    
    static func getSignIns(_ date: String, subj: Subject) -> [SignIn] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(SignIn.self).sorted(byKeyPath: "createdTime", ascending: false).filter("createdTime CONTAINS '\(date)'  and student.subject.classerName == '\(subj.classerName)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [SignIn]
    }
    
    static func getSignIns( _ subj: Subject) -> [SignIn] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(SignIn.self).sorted(byKeyPath: "createdTime", ascending: false).filter("student.subject.classerName == '\(subj.classerName)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [SignIn]
    }
    
    
    static func getAllSignIns() -> [SignIn] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(SignIn.self).sorted(byKeyPath: "createdTime", ascending: false)
        let array = results.get(offset: 0, limit: results.count)
        return array as! [SignIn]
    }

}



extension Results {
    
    func get <T:Object> (offset: Int = 0, limit: Int ) -> Array<T> {
        //create variables
        var lim = 0 // how much to take
        var off = 0 // start from
        var l: Array<T> = Array<T>() // results list
        
        //check indexes
        if off<=offset && offset<self.count - 1 {
            off = offset
        }
        if limit > self.count {
            lim = self.count
        }else{
            lim = limit
        }
        
        //do slicing
        for i in off..<lim{
            let dog = self[i] as! T
            l.append(dog)
        }
        
        //results
        return l
    }
}
