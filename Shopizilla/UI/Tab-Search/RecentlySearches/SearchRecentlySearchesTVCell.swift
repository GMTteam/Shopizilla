//
//  SearchRecentlySearchesTVCell.swift
//  Shopizilla
//
//  Created by Anh Tu on 26/04/2022.
//

import UIKit

protocol SearchRecentlySearchesCVCellDelegate: AnyObject {
    func removeKeywordDidTap(_ cell: SearchRecentlySearchesCVCell)
}

class SearchRecentlySearchesCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "SearchRecentlySearchesCVCell"
    weak var delegate: SearchRecentlySearchesCVCellDelegate?
    
    let containerView = UIView()
    let removeBtn = ButtonAnimation()
    let titleLbl = UILabel()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
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

extension SearchRecentlySearchesCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - ContainerView
        let height: CGFloat = 35.0
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = height/2
        containerView.backgroundColor = UIColor(hex: 0xF5F5F5)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        //TODO: - Removebtn
        removeBtn.setImage(UIImage(named: "icon-cancel")?.withRenderingMode(.alwaysTemplate), for: .normal)
        removeBtn.clipsToBounds = true
        removeBtn.layer.cornerRadius = height/2
        removeBtn.backgroundColor = UIColor(hex: 0xC8C8C8)
        removeBtn.tintColor = .white
        removeBtn.delegate = self
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(removeBtn)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppRegular, size: 16.0)
        titleLbl.textColor = .darkGray
        titleLbl.textAlignment = .center
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLbl)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            removeBtn.widthAnchor.constraint(equalToConstant: height),
            removeBtn.heightAnchor.constraint(equalToConstant: height),
            removeBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            removeBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            titleLbl.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: removeBtn.leadingAnchor),
            titleLbl.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}

//MARK: - ButtonAnimationDelegate

extension SearchRecentlySearchesCVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        delegate?.removeKeywordDidTap(self)
    }
}
