//
//  ViewAnimation.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 02/04/2022.
//

import UIKit

protocol ViewAnimationDelegate: AnyObject {
    func viewAnimationDidTap(_ sender: ViewAnimation)
}

class ViewAnimation: UIButton {
    
    //MARK: - Properties
    weak var delegate: ViewAnimationDelegate?
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if !isTouch { isTouch = true }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if isTouch {
            isTouch = false
            delegate?.viewAnimationDidTap(self)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if isTouch { isTouch = false }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        
        if let parent = superview {
            isTouch = frame.contains(touch.location(in: parent))
        }
    }
}
