//
//  UIImage+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 02/12/2021.
//

import UIKit

extension UIImage {
    
    func setScale(_ width: CGFloat) -> UIImage {
        /*
         - i = size.width/width: Tính được tỉ lệ từ Size thật của Image so với Size hiện tại
         - self.scale*i: Ý nghĩa của giá trị này là 1/i
         */
        
        let s = size.width/width
        return UIImage(cgImage: self.cgImage!, scale: self.scale*s, orientation: self.imageOrientation)
    }
    
    func resizeImage() -> UIImage {
        let scale = size.width / size.height
        let height: CGFloat = 1000.0
        let width = height * scale
        let newSize = CGSize(width: width, height: height)
        let newRect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: newRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        var newImage: UIImage?
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        
        if let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage {
            context.interpolationQuality = .high
            
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(cgImage, in: newRect)
            
            if let img = context.makeImage() {
                newImage = UIImage(cgImage: img)
            }
            
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
    
    // Rotation extension for UIImage because of rotation bug in CGImage generation.
    func rotate(radians: CGFloat) -> UIImage? {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        
        if let context = UIGraphicsGetCurrentContext() {
            defer { UIGraphicsEndImageContext() }
            
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            
            draw(in: CGRect(x: -origin.x, y: -origin.y, width: size.width, height: size.height))
            
            if let rotatedImage = UIGraphicsGetImageFromCurrentImageContext() {
                return rotatedImage
            }
            
            return nil
        }
        
        return nil
    }
    
    func toCIImage() -> CIImage? {
        return self.ciImage ?? CIImage(cgImage: self.cgImage!)
    }
    
    ///Chuyển đổi UIImage thành Data
    func converImageToData() -> Data? {
        let jpegData = self.jpegData(compressionQuality: 1)
        
        if imageOrientation == .up {
            return self.pngData() ?? jpegData
        }
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = scale
        
        let pngData = UIGraphicsImageRenderer(size: size, format: format).image { _ in
            draw(at: .zero)
        }.pngData()
        
        return pngData ?? jpegData
    }
    
    func resetOrientation() -> UIImage {
        // Image has no orientation, so keep the same
        if imageOrientation == .up {
            return self
        }
        
        // Process the transform corresponding to the current orientation
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:           // EXIF = 3, 4
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:           // EXIF = 6, 5
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            
        case .right, .rightMirrored:          // EXIF = 8, 7
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: -CGFloat((Double.pi / 2)))
        default:
            ()
        }
        
        switch imageOrientation {
        case .upMirrored, .downMirrored:     // EXIF = 2, 4
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:   // EXIF = 5, 7
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            ()
        }
        
        // Draw a new image with the calculated transform
        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: cgImage!.bitsPerComponent,
                                bytesPerRow: 0,
                                space: cgImage!.colorSpace!,
                                bitmapInfo: cgImage!.bitmapInfo.rawValue)
        context?.concatenate(transform)
        switch imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context?.draw(cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        if let newImageRef =  context?.makeImage() {
            let newImage = UIImage(cgImage: newImageRef)
            return newImage
        }
        
        // In case things go wrong, still return self.
        return self
    }
}
