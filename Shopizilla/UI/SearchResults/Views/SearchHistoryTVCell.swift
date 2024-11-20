//
//  SearchHistoryTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 19/04/2022.
//

import UIKit

class SearchHistoryTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "SearchHistoryTVCell"
    
    let iconImageView = UIImageView()
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
            updateAnimation(self, isEvent: isTouch, alpha: 0.9)
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

extension SearchHistoryTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .white
        backgroundColor = .white
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.image = UIImage(named: "icon-history")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppRegular, size: 16.0)
        titleLbl.textColor = .black
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLbl)
        contentView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20.0)
        ])
    }
}
