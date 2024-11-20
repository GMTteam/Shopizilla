//
//  RateStackView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

protocol RateStackViewDelegate: AnyObject {
    func rateDidTap(_ rating: Int)
}

class RateStackView: UIStackView {
    
    //MARK: - Properties
    weak var delegate: RateStackViewDelegate?
    
    private var arrayBtn: [UIButton] = []
    
    private var height: CGFloat = 50.0
    private var rating = 0 { didSet { updateBtn() } }
    
    //MARK: - Initialzies
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBtn()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension RateStackView {
    
    func setupBtn() {
        for btn in arrayBtn {
            removeArrangedSubview(btn)
            btn.removeFromSuperview()
        }
        
        arrayBtn.removeAll()
        
        let bundle = Bundle(for: type(of: self))
        let normalImg = UIImage(named: "icon-starNormal", in: bundle, compatibleWith: traitCollection)
        let highlightImg = UIImage(named: "icon-starHighlighted", in: bundle, compatibleWith: traitCollection)
        let selectedImg = UIImage(named: "icon-starFilled", in: bundle, compatibleWith: traitCollection)
        
        for _ in 0..<5 {
            let btn = UIButton()
            btn.setImage(normalImg, for: .normal)
            btn.setImage(highlightImg, for: .highlighted)
            btn.setImage(selectedImg, for: .selected)
            btn.addTarget(self, action: #selector(btnDidTap), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.heightAnchor.constraint(equalToConstant: height).isActive = true
            btn.widthAnchor.constraint(equalToConstant: height).isActive = true
            
            spacing = 3.0
            addArrangedSubview(btn)
            arrayBtn.append(btn)
        }
        
        updateBtn()
    }
    
    func updateBtn() {
        for (index, btn) in arrayBtn.enumerated() {
            btn.isSelected = index < rating
        }
    }
    
    @objc func btnDidTap(_ sender: UIButton) {
        let index = arrayBtn.firstIndex(of: sender)!
        let selected = index + 1
        
        if selected == rating {
            rating = 0
            
        } else {
            rating = selected
        }
        
        delegate?.rateDidTap(rating)
    }
}
