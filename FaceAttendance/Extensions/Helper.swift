//
//  Helper.swift
//  FaceAttendance
//
//  Created by Jerry on 2019/5/25.
//  Copyright © 2019 OVO. All rights reserved.
//

import Foundation
import UIKit

extension String {
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
}

extension UINavigationItem {
    @objc func setTwoLineTitle(lineOne: String, lineTwo: String) {
        let titleParameters = [NSAttributedString.Key.foregroundColor : UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00),
                               NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        let subtitleParameters = [NSAttributedString.Key.foregroundColor : UIColor(red:0.07, green:0.07, blue:0.07, alpha:1.00),
                                  NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13)]
        
        let title:NSMutableAttributedString = NSMutableAttributedString(string: lineOne, attributes: titleParameters)
        let subtitle:NSAttributedString = NSAttributedString(string: lineTwo, attributes: subtitleParameters)
        
        title.append(NSAttributedString(string: "\n"))
        title.append(subtitle)
        
        let size = title.size()
        
        let width = size.width
        let height = CGFloat(44)
        
        let titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        titleLabel.attributedText = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        titleView = titleLabel
    }
}



extension UIViewController {

    // back
    @objc func popBack() {
        if let root = self.navigationController?.viewControllers[0] {
            if root == self {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                let _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }

}


extension Date {
    
    func dateString(_ format: String = "MM-dd-YYYY") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension UIImage {
    
    /// 保存图片到本地, 返回图片名称
    ///
    /// 获取图片路径
    /// ```
    /// let path = FileManager.documentsDirectory.appendingPathComponent(imageName)
    /// ```
    ///
    func saveToDoc() -> String {
        // get the documents directory url
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = String.random(length: 10) + ".jpg"
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = self.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                print("file saved")
                return fileName
            } catch {
                print("error saving file:", error)
                return ""
            }
        }
        return ""
    }
}

extension UIImage {
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}


extension String {
    /**
     Get the width with the string.
     
     - parameter font: The font.
     
     - returns: The string's width.
     */
    func widthWithFont(font : UIFont = UIFont.systemFont(ofSize: 18)) -> CGFloat {
        guard self.count > 0 else {
            return 0
        }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let rect = self.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
        
        return rect.size.width
    }
}
