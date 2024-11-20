//
//  CityTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 30/04/2022.
//

import UIKit

class CityTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "CityTVCell"
    
    let nameLbl = UILabel()
    
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
        if isTouch { isTouch = false }
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

extension CityTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - NameLbl
        nameLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        nameLbl.textColor = .black
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            nameLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            nameLbl.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20.0),
        ])
    }
}
