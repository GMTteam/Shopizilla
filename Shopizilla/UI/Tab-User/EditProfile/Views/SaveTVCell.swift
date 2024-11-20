//
//  SaveTVCell.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

class SaveTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "SaveTVCell"
    
    let saveBtn = ButtonAnimation()
    
    //MARK: - Initializes
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configures

extension SaveTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - SaveBtn
        let saveH: CGFloat = 50.0
        let startAttr = createMutableAttributedString(fgColor: .white, txt: "Save".localized())
        saveBtn.setAttributedTitle(startAttr, for: .normal)
        saveBtn.clipsToBounds = true
        saveBtn.backgroundColor = defaultColor
        saveBtn.layer.cornerRadius = saveH/2
        saveBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(saveBtn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            saveBtn.heightAnchor.constraint(equalToConstant: saveH),
            saveBtn.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            saveBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
            saveBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}
