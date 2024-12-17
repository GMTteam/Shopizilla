//
//  ChatHeaderView.swift
//  Shopizilla
//
//  Created by Anh Tu on 28/05/2022.
//

import UIKit

class ChatHeaderView: UICollectionReusableView {
    
    //MARK: - Properties
    static let id = "ChatHeaderView"
    
    let timeLbl = UILabel()
    
    var groupMes: GroupChat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension ChatHeaderView {
    
    private func setupViews() {
        backgroundColor = .white
        
        //TODO: - TimeLbl
        timeLbl.font = UIFont(name: FontName.ppSemiBold, size: 14.0)
        timeLbl.textColor = .darkGray
        timeLbl.textAlignment = .center
        addSubview(timeLbl)
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            timeLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
