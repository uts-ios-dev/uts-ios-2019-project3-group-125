//
//  ViewController.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import UIKit
import EasyPeasy

fileprivate let reuseIdentifier = "IndexCell"

fileprivate let sectionInsets = UIEdgeInsets(top: 5, left: 15, bottom: 0.0, right: 15)
fileprivate let itemsPerRow: CGFloat = 2


class IndexViewController: MTBaseViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    
    fileprivate var courses: [Subject] = [] //[""]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(image: UIImage(named: "mine")! , style: .plain, target: self, action: #selector(toMine))
        navigationItem.leftBarButtonItem = item
        
        title = "Student attendance system"
        
        courses = Subject.getAllSubject().filter({$0.teacher == User.shared.name})
        
        collection.reloadData()
    }
    
    
    @objc func toMine() {
        let vc = UIStoryboard.Scene.mine
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}




extension IndexViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        return courses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IndexGuidesCell
        
        cell.bind(courses[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "IndexGuidesHeaderView",
                                                                             for: indexPath) as! IndexGuidesHeaderView
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
}

extension IndexViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let heightPerItem = widthPerItem * (264.0 / 220.0) 
        print(paddingSpace)
        print(availableWidth)
        print(widthPerItem)
        print(heightPerItem)
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: collectionView.width, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

extension IndexViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let vc = self.storyboard!.instantiateVC(SubjectDetailViewController.self)!
        vc.sub = courses[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}



class IndexGuidesHeaderView: UICollectionReusableView {
    
}



class IndexGuidesCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
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
        self.backgroundColor = .clear
    }
    
    
    func bind(_ info: Subject) {
        nameLabel.text = info.classerName
        timeLabel.text = info.datetime
    }
    
}
