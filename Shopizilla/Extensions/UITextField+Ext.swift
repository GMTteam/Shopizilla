//
//  UITextField+Ext.swift
//  Fashi
//
//  Created by Jack Ily on 07/03/2020.
//  Copyright © 2020 Jack Ily. All rights reserved.
//

import UIKit

internal extension UITextField {
    
    func searchTF(_ parentV: UIView, width: CGFloat, dl: UITextFieldDelegate, bgColor: UIColor = .white, removeBtn: ButtonAnimation) {
        //TODO: - Placeholder
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppRegular, size: 16.0)!,
            .foregroundColor : UIColor.gray
        ]
        let attrP = NSMutableAttributedString(string: "Search".localized(), attributes: att)
        
        //TODO: - Left
        let img = UIImage(named: "icon-search")?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: img)
        imgView.frame.origin = CGPoint(x: 5.0, y: 0.0)
        
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 32.0, height: 22.0))
        leftView.backgroundColor = .clear
        leftView.addSubview(imgView)
        
        //TODO: - Right
        removeBtn.frame = CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0)
        removeBtn.clipsToBounds = true
        removeBtn.setImage(UIImage(named: "icon-searchRemove")?.withRenderingMode(.alwaysTemplate), for: .normal)
        removeBtn.tintColor = UIColor(hex: 0x8E8E93)
        
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 36.0, height: 36.0))
        rightView.backgroundColor = .clear
        rightView.addSubview(removeBtn)
        
        self.frame = CGRect(x: 0.0, y: 2.0, width: width, height: 36.0)
        self.tintColor = .gray
        self.delegate = dl
        self.layer.cornerRadius = 10.0
        self.rightView = rightView
        self.rightViewMode = .always
        
        self.setupTF(leftView, attrP, bgColor: bgColor)
        parentV.addSubview(self)
    }
    
    func setupLeftRightViewTF(_ placeholderTxt: String, imgName: String, rightImgView: UIImageView, bgColor: UIColor = .white) {
        setupLeftViewTF(placeholderTxt, imgName: imgName, bgColor: bgColor)
        
        let size = CGSize(width: 40.0, height: 40.0)
        let rightPoint = CGPoint(x: 2.5, y: 0.0)
        rightImgView.image = UIImage(named: "icon-eyeOn")?.withRenderingMode(.alwaysTemplate)
        rightImgView.tintColor = defaultColor
        rightImgView.isUserInteractionEnabled = true
        rightImgView.frame = CGRect(origin: rightPoint, size: size)
        
        let rView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 45.0, height: 40.0))
        rView.backgroundColor = .clear
        rView.addSubview(rightImgView)
        
        rightView = rView
        rightViewMode = .always
    }
    
    func setupLeftViewTF(_ placeholderTxt: String, imgName: String, bgColor: UIColor = .white) {
        let att: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppRegular, size: 17.0)!,
            .foregroundColor : UIColor.gray
        ]
        let attr = NSMutableAttributedString(string: placeholderTxt, attributes: att)
        
        let img = UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate)
        let imgView = UIImageView(image: img)
        let size = CGSize(width: 30.0, height: 30.0)
        let point = CGPoint(x: 5.0, y: 0.0)
        imgView.tintColor = defaultColor
        imgView.frame = CGRect(origin: point, size: size)
        
        let separatorP = CGPoint(x: 39.0, y: 5.0)
        let separatorS = CGSize(width: 1.0, height: 20.0)
        let separatorView = UIView(frame: CGRect(origin: separatorP, size: separatorS))
        separatorView.backgroundColor = .gray
        
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 45.0, height: 30.0))
        view.backgroundColor = .clear
        view.addSubview(imgView)
        view.addSubview(separatorView)
        
        setupTF(view, attr, bgColor: bgColor)
        
        font = UIFont(name: FontName.ppRegular, size: 17.0)
        layer.cornerRadius = 50/2
        layer.borderWidth = 1.0
        layer.borderColor = bgColor.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: (screenWidth*0.95)-40).isActive = true
        heightAnchor.constraint(equalToConstant: 50.0).isActive = true
    }
    
    private func setupTF(_ view: UIView, _ attributedP: NSMutableAttributedString, bgColor: UIColor = .white) {
        leftViewMode = .always
        leftView = view
        backgroundColor = bgColor
        attributedPlaceholder = attributedP
        clipsToBounds = true
    }
}
