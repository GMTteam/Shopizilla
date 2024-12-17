//
//  PurchaseTF.swift
//  Zilla NFTs
//
//  Created by Anh Tu on 11/06/2022.
//

import UIKit

class PurchaseTF: UITextField {
    
    //MARK: - Properties
    private let edge = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    
    //MARK: - Initializes
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: edge)
    }
}
