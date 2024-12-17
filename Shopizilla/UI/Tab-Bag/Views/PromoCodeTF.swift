//
//  PromoCodeTF.swift
//  Shopizilla
//
//  Created by Anh Tu on 30/04/2022.
//

import UIKit

class PromoCodeTF: UITextField {
    
    private let edge = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    func addDoneBtn(target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: selector)
        let barBtn = UIBarButtonItem(title: "Done".localized(), style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barBtn], animated: false)
        inputAccessoryView = toolBar
    }
}
