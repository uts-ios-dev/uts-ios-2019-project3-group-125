//
//  IndexCell.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import UIKit

class IndexCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var flagImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
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
        
        flagImageView.isHidden = true
        
        //imageView.contentMode = .center
        self.imageView.contentMode = .scaleAspectFill

    }
    
    
    func bind(_ info: JSONMap) {
        
//        if let p = info.urlToImage, let url = URL(string: p) {
//            
//            imageView.kf.setImage(with: url)
//        }
//
//        nameLabel.text = info.title
        

    }
    
}
