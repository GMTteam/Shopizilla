//
//  SettingsNotificationTVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 29/04/2022.
//

import UIKit

protocol SettingsNotificationTVCellDelegate: AnyObject {
    func switchDidTap(_ cell: SettingsNotificationTVCell, isOn: Bool)
}

class SettingsNotificationTVCell: UITableViewCell {

    //MARK: - Properties
    static let id = "SettingsNotificationTVCell"
    weak var delegate: SettingsNotificationTVCellDelegate?
    
    let titleLbl = UILabel()
    let switchUI = UISwitch()
    
    //MARK: - Initialize
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configures

extension SettingsNotificationTVCell {
    
    func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppMedium, size: 17.0)
        titleLbl.textColor = .black
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLbl)
        
        //TODO: - IconImageView
        switchUI.isOn = true
        switchUI.addTarget(self, action: #selector(switchDidTap), for: .valueChanged)
        switchUI.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(switchUI)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            titleLbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20.0),
            
            switchUI.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switchUI.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20.0),
        ])
    }
    
    @objc private func switchDidTap(_ sender: UISwitch) {
        delegate?.switchDidTap(self, isOn: sender.isOn)
    }
}
