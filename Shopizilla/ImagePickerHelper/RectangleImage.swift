//
//  RectangleImage.swift
//  Zilla NFTs
//
//  Created by Anh Tu on 10/12/2021.
//

import UIKit

class RectangleImage: NSObject {
    
    static let shared = RectangleImage()
    
    override init() {
        super.init()
    }
    
    ///Width > Height
    func rectangleImage(_ image: UIImage, targetSize: CGSize, widthGreaterThanHeight: Bool = false) -> UIImage? {
        var cImage = cropImage(image, targetSize: targetSize)
        
        if widthGreaterThanHeight {
            cImage = cropImage(image)
        }
        
        let size = cImage.size
        let wR: CGFloat = targetSize.width / size.width
        let hR: CGFloat = targetSize.height / size.height
        
        let newSize = CGSize(width: size.width * wR, height: size.height * hR)
        let rect = CGRect(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        cImage.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    ///Width < Height
    private func cropImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let originalW: CGFloat = image.size.width
        let originalH: CGFloat = image.size.height
        let ratio: CGFloat = targetSize.width / targetSize.height
        
        let itemH = originalW > originalH ? originalH : originalW
        let itemW = itemH * ratio
        
        let posX: CGFloat = originalW > originalH ? (originalW - itemW)/2 : 0.0
        let posY: CGFloat = originalW > originalH ? 0.0 : (originalH - itemH)/2
        let rect = CGRect(x: posX, y: posY, width: itemW, height: itemH)
        
        let crop = image.cgImage?.cropping(to: rect)
        let scale: CGFloat = UIScreen.main.scale
        
        let newImage = UIImage(cgImage: crop!, scale: scale, orientation: image.imageOrientation)
        
        return newImage
    }
    
    ///Width > Height
    private func cropImage(_ image: UIImage) -> UIImage {
        let originalW: CGFloat = image.size.width
        let originalH: CGFloat = image.size.height
        
        let itemW = originalW > originalH ? originalH : originalW
        let itemH = itemW * 0.7
        
        let posX: CGFloat = (originalW - itemW)/2
        let posY: CGFloat = (originalH - itemH)/2
        let rect = CGRect(x: posX, y: posY, width: itemW, height: itemH)
        
        let crop = image.cgImage?.cropping(to: rect)
        let scale: CGFloat = UIScreen.main.scale
        
        let newImage = UIImage(cgImage: crop!, scale: scale, orientation: image.imageOrientation)
        
        return newImage
    }
}
