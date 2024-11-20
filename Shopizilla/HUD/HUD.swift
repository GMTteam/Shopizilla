//
//  HUD.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 23/11/2021.
//

import UIKit

class HUD: UIView {
    
    class func hud(_ view: UIView, effect: Bool = true) -> HUD {
        let hud = HUD(frame: view.bounds)
        
        view.insertSubview(hud, at: 10)
        hud.isUserInteractionEnabled = true
        hud.isOpaque = false
        hud.backgroundColor = UIColor(hex: 0x000000, alpha: 0.1)
        animate(hud: hud, effect: effect)
        
        return hud
    }
    
    override func draw(_ rect: CGRect) {
        let boxHeight: CGFloat = 90.0
        let rect = CGRect(x: (bounds.size.width - boxHeight)/2.0,
                          y: (bounds.size.height - boxHeight)/2.0,
                          width: boxHeight,
                          height: boxHeight)
        let bezierPath = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        UIColor(white: 0.3, alpha: 0.7).setFill()
        bezierPath.fill()
        
        let dotView = DotView()
        addSubview(dotView)
        dotView.center = center
    }
    
    class func animate(hud: HUD, effect: Bool) {
        if effect {
            hud.alpha = 0.0
            UIView.animate(withDuration: 0.33) { hud.alpha = 1.0 }
        }
    }
    
    func removeHUD(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.33, animations: {
            self.alpha = 0.0
            
        }) { (_) in
            self.removeFromSuperview()
            completion()
        }
    }
}
