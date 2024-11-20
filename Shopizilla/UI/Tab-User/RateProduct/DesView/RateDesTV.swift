//
//  RateDesTV.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

class RateDesTV: UITextView {
    
    func addDoneBtn(target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: target, action: selector)
        let barBtn = UIBarButtonItem(title: "Done".localized(), style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barBtn], animated: false)
        inputAccessoryView = toolBar
    }
}
