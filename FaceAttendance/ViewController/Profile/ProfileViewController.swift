//
//  ProfileViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit

private let titles:[String] = []

class ProfileViewController: MTBaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        nameLabel.text = "Name: "
        ageLabel.text = "Sex: "
        emailLabel.text = "MobileNo: "
        
        if let user :JSONMap = UserDefaults.standard.dictionary(forKey: kUserInfo) {
            if let v =  user["name"] as? String {
                nameLabel.text = v
            }
            if let v = user["sex"] as? String {
                ageLabel.text = "Sex: " + v
            }
            if let v =  user["mobile"] as? String {
                emailLabel.text = "MobileNo: " + v
            }
            
            if let v =  user["subjects"] as? String {
                subsLabel.text = "Courses: " + v
            }

        }
    }
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var subsLabel: UILabel!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        addNavigationBarLeftButton(self)
        
        //topImageView.kf.setImage(with: URL(string: aaa))
        
        //table.tableHeaderView?.height = 200
    }
    

    
    @IBAction func signout() {
        AppDelegate.shared.signout()
        
    }
    
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
            
        default:
            print("")
        }
    }
}


extension ProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = MTColor.main
        
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
        
    }
    
}
