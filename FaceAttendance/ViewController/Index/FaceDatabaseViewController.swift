//
//  FaceDatabaseViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit


fileprivate let reuseIdentifier = "Cell"

fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 8, bottom: 0.0, right: 8)
fileprivate let itemsPerRow: CGFloat = 3

class FaceDatabaseViewController: MTBaseViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    
    var sub: Subject?
    
    var students: [JSONMap] = []
    
    /// 已录入
    var enteredStus: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Student face library"
        addNavigationBarLeftButton(self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
    
    private func reload() {
        students = []
        enteredStus = []
        
        if let  s = sub {
            //title = s.classerName + " face library"
            self.navigationItem.setTwoLineTitle(lineOne: s.classerName, lineTwo: "face library")
            
            Plist.array(.student, success: { (list) in
                self.students = list.filter({$0["classer"] as! String == s.classerName})
                
                enteredStus = Student.getStudentBySubject(s.classerName)
                
                for (index, item) in students.enumerated() {
                    let rec = enteredStus.filter({$0.user_id == String(item["no"] as! Int)})
                    if rec.count > 0 {
                        students[index]["face"] = rec[0].face
                    }
                }
                
                collection.reloadData()
            }) { (erro) in
                showMessage(erro.localizedDescription)
            }
        }
    }
    


}



extension FaceDatabaseViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return students.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HeaderCell
        
        cell.bind(students[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header",
                                                                             for: indexPath)
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
}

extension FaceDatabaseViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (320.0 / 200.0)
//        print(paddingSpace)
//        print(availableWidth)
//        print(widthPerItem)
//        print(heightPerItem)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.width, height: 10)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension FaceDatabaseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if let _ = students[indexPath.row]["face"] as? String {
            return
        }
        let vc = UIStoryboard.Scene.camera
        vc.student = students[indexPath.row]
        let nav = MTNavigationController(rootViewController: vc)
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
}


class HeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: BFImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var noLabel: UILabel!
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            //imageView.layer.borderWidth = isSelected ? 10 : 0
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        //imageView.layer.borderColor = themeColor.cgColor
        isSelected = false
        self.backgroundColor = UIColor(red:0.96, green:0.97, blue:0.96, alpha:1.00)
        self.cornerRadius = 5
    }
    
    
    func bind(_ info: JSONMap) {
        nameLabel.text = info["name"] as? String
        
        if let no = info["no"] as? Int {
            noLabel.text = String(no)
        }
        
        imageView.image = UIImage(named: "stu_def")
        if let face = info["face"] as? String {
            let img = UIImage(contentsOfFile: FileManager.documentsDirectory.appendingPathComponent(face))
            imageView.image = img
            
        }
    }
    
}




