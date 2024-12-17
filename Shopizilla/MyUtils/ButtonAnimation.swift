//
//  ButtonAnimation.swift
//  Shopizilla
//
//  Created by Anh Tu on 02/04/2022.
//

import UIKit

protocol ButtonAnimationDelegate: AnyObject {
    func btnAnimationDidTap(_ sender: ButtonAnimation)
}

class ButtonAnimation: UIButton {
    
    //MARK: - Properties
    weak var delegate: ButtonAnimationDelegate?
    
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
            delegate?.btnAnimationDidTap(self)
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

func updateAnimation(_ view: UIView, isEvent: Bool, alpha: CGFloat = 0.5) {
    let al: CGFloat = isEvent ? alpha : 1.0
    
    UIView.animate(withDuration: 0.15) {
        view.alpha = al
    }
}
