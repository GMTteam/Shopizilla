//
//  ShareTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/05/2022.
//

import UIKit

class ShareTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "ShareTVCell"
    
    let iconImgView = UIImageView()
    let titleLbl = UILabel()
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var isTouch = false {
        didSet {
            updateAnimation(self, isEvent: isTouch, alpha: 0.5)
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

//MARK: - Configures

extension ShareTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - Icon
        let iconH: CGFloat = 20.0
        iconImgView.contentMode = .scaleAspectFit
        iconImgView.clipsToBounds = true
        iconImgView.tintColor = .black
        iconImgView.translatesAutoresizingMaskIntoConstraints = false
        iconImgView.widthAnchor.constraint(equalToConstant: iconH).isActive = true
        iconImgView.heightAnchor.constraint(equalToConstant: iconH).isActive = true
        
        //TODO: - Title
        titleLbl.font = UIFont(name: FontName.ppRegular, size: 17.0)
        titleLbl.text = ""
        titleLbl.textColor = defaultColor
        
        //TODO: - UIStackView
        let sv = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        sv.addArrangedSubview(iconImgView)
        sv.addArrangedSubview(titleLbl)
        contentView.addSubview(sv)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
        ])
    }
}
