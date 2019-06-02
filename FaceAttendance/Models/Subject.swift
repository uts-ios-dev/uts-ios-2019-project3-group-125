//
//  Subject.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import RealmSwift
import Realm


/// 课程
class Subject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var teacher: String = ""
    @objc dynamic var classerName: String = ""      //教学班名称
    @objc dynamic var groupName: String = ""      //教学班英文名称 （caozuoxitong1ban） ,用于百度group名称
    @objc dynamic var datetime: String = ""
    override static func primaryKey() -> String? {
        return "id"
    }
}



func == (lhs: Subject, rhs:Subject) -> Bool
{
    return lhs.id == rhs.id
}

extension Subject {
    static func add(_ id: Int, teacher: String, classerName: String, datetime: String) {
        let goods = Subject()
        goods.id = id
        goods.teacher = teacher
        goods.classerName = classerName
        goods.datetime = datetime
        goods.groupName = classerName.replace(" ", withString: "")
        //goods.week = week
        //goods.time = String(Date().toString("hh:mm:ss"))
        
        var exsit = false
        for go in Subject.getAllSubject() {
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
    
    func deleteBy(_ id: Int) {
        let cos = Subject.getAllSubject()
        cos.forEach {
            if $0.id == id {
                $0.delete()
            }
        }
    }
    
    
    static func getAllSubject() -> [Subject] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Subject.self).sorted(byKeyPath: "id", ascending: false)
        let array = results.get(offset: 0, limit: results.count)
        return array as! [Subject]
    }
    
    static func getAllSubjectByName(_ name: String) -> [Subject] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Subject.self).sorted(byKeyPath: "id", ascending: false).filter("name = '\(name)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [Subject]
    }
    
    static func getAllSubjectByClasserName(_ name: String) -> [Subject] {
        let realm = try! Realm() // Create realm pointing to default file
        let results = realm.objects(Subject.self).sorted(byKeyPath: "id", ascending: false).filter("classerName = '\(name)'")
        let array = results.get(offset: 0, limit: results.count)
        return array as! [Subject]
    }
    
    /// 读取plist
    static func loadDefaultData() {
        Plist.array(.sub, success: { (subs) in
            if subs.count == Subject.getAllSubject().count {return}
            
            subs.forEach({
                Subject.add($0["id"] as! Int, teacher: $0["teacher"] as! String, classerName: $0["classerName"] as! String, datetime: $0["datetime"] as! String)
            })
        }) { (err) in
            showMessage(err.localizedDescription)
        }
        
    }
}
