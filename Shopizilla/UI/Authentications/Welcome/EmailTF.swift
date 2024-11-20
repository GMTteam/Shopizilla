//
//  EmailTF.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit

class EmailTF: UITextField {
    
    /*
    private let edge = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard action == #selector(UIResponderStandardEditActions.paste(_:)) else {
            return super.canPerformAction(action, withSender: sender)
        }

        return false
    }
    */
    
    func addDoneBtn(target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: selector)
        let barBtn = UIBarButtonItem(title: "Done".localized(), style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barBtn], animated: false)
        inputAccessoryView = toolBar
    }
}
