//
//  SearchCategoriesTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchCategoriesTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "SearchCategoriesTVCell"
    
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

extension SearchCategoriesTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 16.0)
        titleLbl.textColor = .darkGray
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
