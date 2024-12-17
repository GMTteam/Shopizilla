//
//  HUDSave.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/06/2022.
//

import UIKit

class HUDSave: UIView {
    
    let aboveTxt = NSString(string: "Please Wait".localized())
    var belowTxt: NSString = ""
    
    class func hud(_ view: UIView, effect: Bool = true) -> HUDSave {
        let hud = HUDSave(frame: view.bounds)
        
        view.insertSubview(hud, at: 10)
        hud.isUserInteractionEnabled = true
        hud.isOpaque = false
        hud.backgroundColor = UIColor(hex: 0x000000)
        animate(hud: hud, effect: effect)
        
        return hud
    }
    
    override func draw(_ rect: CGRect) {
        let aboveAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppMedium, size: 14)!,
            .foregroundColor: UIColor.white
        ]
        let aboveSize = aboveTxt.size(withAttributes: aboveAtt)
        let abovePt = CGPoint(x: center.x - round(aboveSize.width/2),
                              y: center.y - round(aboveSize.height/2))
        aboveTxt.draw(at: abovePt, withAttributes: aboveAtt)
        
        let belowAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: FontName.ppBold, size: 18)!,
            .foregroundColor: UIColor.white
        ]
        let belowSize = belowTxt.size(withAttributes: belowAtt)
        let belowPt = CGPoint(x: center.x - round(belowSize.width/2),
                              y: center.y + round(belowSize.height/2))
        belowTxt.draw(at: belowPt, withAttributes: belowAtt)
        
    }
    
    class func animate(hud: HUDSave, effect: Bool) {
        if effect {
            hud.alpha = 0.0
            UIView.animate(withDuration: 0.33) { hud.alpha = 1.0 }
            
        } else {
            hud.alpha = 1.0
        }
    }
    
    func removeHUD(effect: Bool = true, completion: @escaping () -> Void) {
        if effect {
            UIView.animate(withDuration: 0.33, animations: {
                self.alpha = 0.0
                
            }) { (_) in
                self.removeFromSuperview()
                completion()
            }
            
        } else {
            removeFromSuperview()
            completion()
        }
    }
}
