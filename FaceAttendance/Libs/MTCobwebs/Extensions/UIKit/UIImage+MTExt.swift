//
//  UIImage+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit
import ImageIO
import MobileCoreServices
import Accelerate

// MARK: - Initializers
public extension UIImage {
    
    /// Create UIImage from color and size.
    ///
    /// - Parameters:
    ///   - color: image fill color.
    ///   - size: image size.
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            self.init()
            return
        }
        UIGraphicsEndImageContext()
        guard let aCgImage = image.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: aCgImage)
    }
    
}

// MARK: - Properties
public extension UIImage {
    
    /// Size in bytes of UIImage
    var bytesSize: Int {
        return self.jpegData(compressionQuality: 1)?.count ?? 0
    }
    
    /// Size in kilo bytes of UIImage
    var kilobytesSize: Int {
        return bytesSize / 1024
    }
    
    /// UIImage with .alwaysOriginal rendering mode.
    var original: UIImage {
        return withRenderingMode(.alwaysOriginal)
    }
    
    /// UIImage with .alwaysTemplate rendering mode.
    var template: UIImage {
        return withRenderingMode(.alwaysTemplate)
    }
    
}

public extension UIImage {

    /// 根据颜色生成图片
    ///
    /// - Parameter color: 颜色
    /// - Returns: 结果图片
	static func image(withColor color: UIColor) -> UIImage {
		let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
		UIGraphicsBeginImageContext(rect.size)
		let context = UIGraphicsGetCurrentContext()

		context?.setFillColor(color.cgColor)
		context?.fill(rect)

		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return image!
	}
}

public extension UIImage {
    
    /// 截取中心最大正方形图片
    ///
    /// - Returns: 结果图片
	func largestCenteredSquareImage() -> UIImage {
		let scale = self.scale

		let originalWidth = self.size.width * scale
		let originalHeight = self.size.height * scale

		let edge: CGFloat
		if originalWidth > originalHeight {
			edge = originalHeight
		} else {
			edge = originalWidth
		}

		let posX = (originalWidth - edge) / 2.0
		let posY = (originalHeight - edge) / 2.0

		let cropSquare = CGRect(x: posX, y: posY, width: edge, height: edge)

		let imageRef = self.cgImage?.cropping(to: cropSquare)!

		return UIImage(cgImage: imageRef!, scale: scale, orientation: self.imageOrientation)
	}
    
    /// 编辑图片大小
    ///
    /// - Parameter targetSize: 目标尺寸
    /// - Returns: image
	func resizeTo(_ targetSize: CGSize) -> UIImage {
		let size = self.size

		let widthRatio = targetSize.width / self.size.width
		let heightRatio = targetSize.height / self.size.height

		let scale = UIScreen.main.scale
		let newSize: CGSize
		if (widthRatio > heightRatio) {
			newSize = CGSize(width: scale * floor(size.width * heightRatio), height: scale * floor(size.height * heightRatio))
		} else {
			newSize = CGSize(width: scale * floor(size.width * widthRatio), height: scale * floor(size.height * widthRatio))
		}

		let rect = CGRect(x: 0, y: 0, width: floor(newSize.width), height: floor(newSize.height))

		// println("size: \(size), newSize: \(newSize), rect: \(rect)")

		UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
		self.draw(in: rect)
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return newImage!
	}
    
    /// UIImage Cropped to CGRect.
    ///
    /// - Parameter rect: CGRect to crop UIImage to.
    /// - Returns: cropped UIImage
    func cropped(to rect: CGRect) -> UIImage {
        guard rect.size.width < size.width && rect.size.height < size.height else { return self }
        guard let image: CGImage = cgImage?.cropping(to: rect) else { return self }
        return UIImage(cgImage: image)
    }
    
    /// 质量压缩  循环
    ///
    /// - Parameter expectedSize: 最大尺寸，压缩后不超过此大小 (单位: Byte, 2M = 2 * 1024 * 1024)
    /// - Returns: IMAGE
    func compressTo(_ expectedSize: Int) -> UIImage {
        
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data:Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < expectedSize {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < expectedSize) {
                return UIImage(data: data) ?? self
            }
        }
        return self
    }
    
    /// 质量压缩,返回data  循环
    ///
    /// - Parameter expectedSize: 最大尺寸，压缩后不超过此大小 (单位: Byte, 2M = 2 * 1024 * 1024)
    /// - Returns: IMAGE
    func dataWithCompressTo(_ expectedSize: Int) -> Data {
        
        var needCompress: Bool = true
        var imgData: Data?
        var compressingValue:CGFloat = 1.0
        while (needCompress && compressingValue > 0.0) {
            if let data: Data = self.jpegData(compressionQuality: compressingValue) {
                if data.count < expectedSize {
                    needCompress = false
                    imgData = data
                } else {
                    compressingValue -= 0.1
                }
            }
        }
        
        if let data = imgData {
            if (data.count < expectedSize) {
                return data
            }
        }
        return self.jpegData(compressionQuality: 0.9)!
    }
    
    /// UIImage根据高宽比缩放到高度
    ///
    /// - Parameters:
    ///   - toHeight: new height.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toHeight: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toHeight / size.height
        let newWidth = size.width * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: toHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: toHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// UIImage根据高宽比缩放到宽度
    ///
    /// - Parameters:
    ///   - toWidth: new width.
    ///   - opaque: flag indicating whether the bitmap is opaque.
    /// - Returns: optional scaled UIImage (if applicable).
    func scaled(toWidth: CGFloat, opaque: Bool = false) -> UIImage? {
        let scale = toWidth / size.width
        let newHeight = size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: toWidth, height: newHeight), opaque, 0)
        draw(in: CGRect(x: 0, y: 0, width: toWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// 生成到指定尺寸的最小图片
    ///
    /// - Parameter sideLength: 尺寸
    /// - Returns:  结果图片
	func scaleToMinSideLength(_ sideLength: CGFloat) -> UIImage {

		let pixelSideLength = sideLength * UIScreen.main.scale

		// println("pixelSideLength: \(pixelSideLength)")
		// println("size: \(size)")

		let pixelWidth = size.width * scale
		let pixelHeight = size.height * scale

		// println("pixelWidth: \(pixelWidth)")
		// println("pixelHeight: \(pixelHeight)")

		let newSize: CGSize

		if pixelWidth > pixelHeight {

			guard pixelHeight > pixelSideLength else {
				return self
			}

			let newHeight = pixelSideLength
			let newWidth = (pixelSideLength / pixelHeight) * pixelWidth
			newSize = CGSize(width: floor(newWidth), height: floor(newHeight))

		} else {

			guard pixelWidth > pixelSideLength else {
				return self
			}

			let newWidth = pixelSideLength
			let newHeight = (pixelSideLength / pixelWidth) * pixelHeight
			newSize = CGSize(width: floor(newWidth), height: floor(newHeight))
		}

		if scale == UIScreen.main.scale {
			let newSize = CGSize(width: floor(newSize.width / scale), height: floor(newSize.height / scale))
			// println("A scaleToMinSideLength newSize: \(newSize)")

			UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
			let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
			self.draw(in: rect)
			let newImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

			if let image = newImage {
				return image
			}

			return self

		} else {
			// println("B scaleToMinSideLength newSize: \(newSize)")
			UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
			let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
			self.draw(in: rect)
			let newImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()

			if let image = newImage {
				return image
			}

			return self
		}
	}
    
    /// 根据图片生成方向 转变方向     Adjusts the orientation of the image from the capture orientation.
    ///      This is an issue when taking images, the capture orientation is not set correctly when using Portrait.
    ///
    /// - Returns: An optional UIImage if successful.
	func adjustOrientation() -> UIImage? {
		if self.imageOrientation == .up {
			return self
		}

		let width = self.size.width
		let height = self.size.height

		var transform = CGAffineTransform.identity

		switch self.imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: width, y: height)
			transform = transform.rotated(by: CGFloat(Double.pi))

		case .left, .leftMirrored:
			transform = transform.translatedBy(x: width, y: 0)
			transform = transform.rotated(by: CGFloat(Double.pi / 2))

		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: height)
			transform = transform.rotated(by: CGFloat(-Double.pi / 2))

		default:
			break
		}

		switch self.imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		default:
			break
		}

		let selfCGImage = self.cgImage
        
        // Draw the underlying cgImage with the calculated transform.
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0, space: cgImage!.colorSpace!, bitmapInfo: cgImage!.bitmapInfo.rawValue) else {
            return nil
        }

		context.concatenate(transform)

		switch self.imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			context.draw(selfCGImage!, in: CGRect(x: 0, y: 0, width: height, height: width))

		default:
			context.draw(selfCGImage!, in: CGRect(x: 0, y: 0, width: width, height: height))
		}
        
        guard let cgImage = context.makeImage() else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)

	}
}


public extension UIImage {

    /// 按高宽比截取
    ///
    /// - Parameter aspectRatio: 高宽比
    /// - Returns: 结果图片
	func cropToAspectRatio(_ aspectRatio: CGFloat) -> UIImage {
		let size = self.size

		let originalAspectRatio = size.width / size.height

		var rect = CGRect.zero

		if originalAspectRatio > aspectRatio {
			let width = size.height * aspectRatio
			rect = CGRect(x: (size.width - width) * 0.5, y: 0, width: width, height: size.height)

		} else if originalAspectRatio < aspectRatio {
			let height = size.width / aspectRatio
			rect = CGRect(x: 0, y: (size.height - height) * 0.5, width: size.width, height: height)

		} else {
			return self
		}

		let cgImage = self.cgImage?.cropping(to: rect)!
		return UIImage(cgImage: cgImage!)
	}
}

public extension UIImage {
    
    /// 根据渐变色调的颜色得到图片
    ///
    /// - Parameter tintColor: 色调
    /// - Returns:  结果图片
	func imageWithGradientTintColor(_ tintColor: UIColor) -> UIImage {

		return imageWithTintColor(tintColor, blendMode: CGBlendMode.overlay)
	}

    
    /// 根据色调的颜色得到图片
    ///
    /// - Parameters:
    ///   - tintColor: 色调
    ///   - blendMode: 混合模式
    /// - Returns:  结果图片
	func imageWithTintColor(_ tintColor: UIColor, blendMode: CGBlendMode) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, 0)

		tintColor.setFill()

		let bounds = CGRect(origin: CGPoint.zero, size: size)

		UIRectFill(bounds)

		self.draw(in: bounds, blendMode: blendMode, alpha: 1)

		if blendMode != CGBlendMode.destinationIn {
			self.draw(in: bounds, blendMode: CGBlendMode.destinationIn, alpha: 1)
		}

		let tintedImage = UIGraphicsGetImageFromCurrentImageContext()

		UIGraphicsEndImageContext()

		return tintedImage!
	}
}

public extension UIImage {

    
    /// 根据尺寸重绘
    ///
    /// - Parameter size: 尺寸  确保 size 为整数，防止 mask 里出现白线
    /// - Returns: 结果图片
	func renderAtSize(_ size: CGSize) -> UIImage {

		// 确保 size 为整数，防止 mask 里出现白线
		let size = CGSize(width: ceil(size.width), height: ceil(size.height))

		UIGraphicsBeginImageContextWithOptions(size, false, 0) // key

		let context = UIGraphicsGetCurrentContext()

		draw(in: CGRect(origin: CGPoint.zero, size: size))

		let cgImage = context?.makeImage()!

		let image = UIImage(cgImage: cgImage!)

		UIGraphicsEndImageContext()

		return image
	}
}



public extension UIImage {
    // MARK: - Decode

    
    ///
    ///
    /// - Returns: the decoded image
	func decoded() -> UIImage {
		return decodedWith( scale)
	}

    
    /// decode image
    ///
    /// - Parameter scale: scale
    /// - Returns: the decoded image
	func decodedWith(_ scale: CGFloat) -> UIImage {
		let imageRef = cgImage
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
		let context = CGContext(data: nil, width: (imageRef?.width)!, height: (imageRef?.height)!, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)

		if let context = context {
			let rect = CGRect(x: 0, y: 0, width: CGFloat((imageRef?.width)!), height: CGFloat((imageRef?.height)!))
			context.draw(imageRef!, in: rect)
			let decompressedImageRef = context.makeImage()!

			return UIImage(cgImage: decompressedImageRef, scale: scale, orientation: imageOrientation) 
		}

		return self
	}
}



public extension UIImage {
    // MARK: Resize
    
    
    /// 改变图片尺寸大小
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - transform: 方向
    ///   - drawTransposed: 是否颠倒
    ///   - interpolationQuality:  质量
    /// - Returns: 结果图片
	func resizeTo(_ size: CGSize, withTransform transform: CGAffineTransform, drawTransposed: Bool, interpolationQuality: CGInterpolationQuality) -> UIImage? {

		let newRect = CGRect(origin: CGPoint.zero, size: size).integral
		let transposedRect = CGRect(origin: CGPoint.zero, size: CGSize(width: size.height, height: size.width))

		let bitmapContext = CGContext(data: nil, width: Int(newRect.width), height: Int(newRect.height), bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0, space: (cgImage?.colorSpace!)!, bitmapInfo: (cgImage?.bitmapInfo.rawValue)!)

		bitmapContext?.concatenate(transform)

		bitmapContext!.interpolationQuality = interpolationQuality

		bitmapContext?.draw(cgImage!, in: drawTransposed ? transposedRect : newRect)

		let newCGImage = bitmapContext?.makeImage()!
		let newImage = UIImage(cgImage: newCGImage!)

		return newImage
	}

    /// 图片位置变换
    ///
    /// - Parameter size: 尺寸
    /// - Returns: CGAffineTransform
	func transformForOrientation(_ size: CGSize) -> CGAffineTransform {
		var transform = CGAffineTransform.identity

		switch imageOrientation {
		case .down, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: size.height)
			transform = transform.rotated(by: CGFloat(Double.pi))

		case .left, .leftMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.rotated(by: CGFloat(Double.pi / 2))

		case .right, .rightMirrored:
			transform = transform.translatedBy(x: 0, y: size.height)
			transform = transform.rotated(by: CGFloat(-Double.pi / 2))

		default:
			break
		}

		switch imageOrientation {
		case .upMirrored, .downMirrored:
			transform = transform.translatedBy(x: size.width, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		case .leftMirrored, .rightMirrored:
			transform = transform.translatedBy(x: size.height, y: 0)
			transform = transform.scaledBy(x: -1, y: 1)

		default:
			break
		}

		return transform
	}

    /// 改变图片尺寸大小
    ///
    /// - Parameters:
    ///   - size: 尺寸
    ///   - interpolationQuality:  质量
    /// - Returns: 结果图片
	func resizeTo(_ size: CGSize, withInterpolationQuality interpolationQuality: CGInterpolationQuality) -> UIImage? {

		let drawTransposed: Bool

		switch imageOrientation {
		case .left, .leftMirrored, .right, .rightMirrored:
			drawTransposed = true
		default:
			drawTransposed = false
		}

		return resizeTo(size, withTransform: transformForOrientation(size), drawTransposed: drawTransposed, interpolationQuality: interpolationQuality)
	}
    
    /// 给图片加上圆角
    ///
    /// - Parameter cornerRadius: 圆角弧度
    /// - Returns: 结果图片
    final func imageByRoundingCornersTo(_ cornerRadius: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: cornerRadius, bottom: 0, right: cornerRadius))
    }
    
    
    /// UIImage with rounded corners
    ///
    /// - Parameters:
    ///   - radius: corner radius (optional), resulting image will be round if unspecified
    /// - Returns: UIImage with all corners rounded
    func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
