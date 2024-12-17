//
//  NotifView.swift
//  Shopizilla
//
//  Created by Anh Tu on 18/05/2022.
//

import UIKit

class NotifView: UIView {
    
    //MARK: - Properties
    let notifLbl = UILabel()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension NotifView {
    
    func setupViews(_ view: UIView, naviView: UIView? = nil) {
        //TODO: - NotifView
        clipsToBounds = true
        isHidden = true
        alpha = 0.0
        backgroundColor = .systemGroupedBackground
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        //TODO: - NotifLbl
        notifLbl.font = UIFont(name: FontName.ppSemiBold, size: 16.0)
        notifLbl.textAlignment = .center
        notifLbl.textColor = .black
        notifLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(notifLbl)
        
        if let naviView = naviView {
            topAnchor.constraint(equalTo: naviView.bottomAnchor).isActive = true
            
        } else {
            topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        }
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: screenWidth),
            heightAnchor.constraint(equalToConstant: 50.0),
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            notifLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            notifLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupNotifView(_ txt: String) {
        isHidden = false
        notifLbl.text = txt
        
        UIView.animate(withDuration: 0.5) {
            self.alpha = 1.0
            
        } completion: { _ in
            delay(duration: 0.5) {
                UIView.animate(withDuration: 0.5) {
                    self.alpha = 0.0
                    
                } completion: { _ in
                    self.isHidden = true
                    self.notifLbl.text = ""
                }
            }
        }
    }
}
