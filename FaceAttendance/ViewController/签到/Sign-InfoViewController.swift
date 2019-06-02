//
//  Sign-InfoViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit


fileprivate let reuseIdentifier = "Cell"

fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 8, bottom: 0.0, right: 8)
fileprivate let itemsPerRow: CGFloat = 3


class Sign_InfoViewController: MTBaseViewController {

    @IBOutlet weak var collection: UICollectionView!
    
    var date: String = ""
    var sub: Subject?
    
    var signedStus: [SignIn] = []
    
    /// 已录入
    var enteredStus: [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Student attendance system"
        
        addNavigationBarLeftButton(self)
        
        if let  s = sub {
            //title = s.classerName + "Attendance record"
            self.navigationItem.setTwoLineTitle(lineOne: s.classerName, lineTwo: "Attendance record")
            
            signedStus = SignIn.getSignIns(date, subj: s)
            print(signedStus)
            
            enteredStus = Student.getStudentBySubject(s.classerName)
            
            
            
        }
        
        
    }
    
    
    
}



extension Sign_InfoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return enteredStus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SignRecordCell
        
        cell.bind(enteredStus[indexPath.row], signRecs: signedStus)
        
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

extension Sign_InfoViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (320.0 / 200.0)
        
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

extension Sign_InfoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
}


class SignRecordCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    
    func bind(_ info: Student, signRecs: [SignIn]) {
        nameLabel.text = info.name
        noLabel.text = info.user_id
        
        imageView.image = UIImage(named: "stu_def")
        
        
        let s = signRecs.filter({$0.student == info})
        if s.count > 0 {
            /// 标记已签到的图片
            let img = UIImage(contentsOfFile: FileManager.documentsDirectory.appendingPathComponent(s[0].image))
            imageView.image = img
        } else {
            imageView.tintColor = UIColor.gray
            imageView.image = UIImage(named: "stu_def")?.withRenderingMode(.alwaysTemplate)
        }
        
    }
    
}

