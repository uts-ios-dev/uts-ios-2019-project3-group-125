//
//  SubjectDetailViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit
import EasyPeasy

class SubjectDetailViewController: MTBaseViewController {

    @IBOutlet weak var table: UITableView!
    
    var attendances: JSONMap = [:]
    
    var sub: Subject?
    
    var number: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        number = Student.getStudentBySubject(sub!.classerName).count
        
        table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addNavigationBarLeftButton(self)
        //title = sub!.classerName + "Attendance eecord"
        self.navigationItem.setTwoLineTitle(lineOne: sub!.classerName, lineTwo: "Attendance record")
        
        addNavigationBarRightButton(self, action: #selector(toStudentFaces), image: UIImage(named: "faces")!)
        
        let button = UIButton(type: .custom)
        button.backgroundColor = MTColor.main
        button.setImage(UIImage(named: "add"), for: .normal)
        button.addTarget(self, action: #selector(add), for: .touchUpInside)
        button.cornerRadius = 35
        button.addShadow(ofColor: MTColor.title222.alpha(0.3), offset: CGSize(width: 1, height: 2))
        view.addSubview(button)
        button.easy.layout(Right(25), Width(70), Height(70), Bottom(30).to(self.view.safeAreaLayoutGuide, .bottom))
        
        
        
        number = Student.getStudentBySubject(sub!.classerName).count
        
        
        let signs = SignIn.getSignIns(sub!)
        attendances = Dictionary(grouping: signs, by: { (element: SignIn) in
            return element.createdTime.slicing(length: 10)!
        })
        print(attendances)
        
    }
    
    @objc func toStudentFaces() {
        let vc = self.storyboard!.instantiateVC(FaceDatabaseViewController.self)!
        vc.sub = sub
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func add() {
        let vc = UIStoryboard.Scene.camera
        vc.group = sub?.groupName
        let nav = MTNavigationController(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
}

extension SubjectDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        let vc = UIStoryboard.Scene.signIn
        vc.date = Array(attendances.keys)[indexPath.row]
        vc.sub = sub
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension SubjectDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 10))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendances.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = MTColor.title222
        
        let date = Array(attendances.keys)[indexPath.row]
        cell.textLabel?.text = date
        
        cell.detailTextLabel?.textColor = MTColor.main
        
        if let n = (attendances[date] as? [SignIn])?.count {
            cell.detailTextLabel?.text = n == number ? "Full attendance" : "\(number - n) people absent"
        }
        
        let line = UIView(frame: CGRect(x: 10, y: 60 - 0.5, width: tableView.width - 10, height: 0.5))
        line.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.96, alpha:1.00)
        cell.contentView.addSubview(line)
        
        return cell
    }
    
}
