//
//  BagCenterView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 27/04/2022.
//

import UIKit
import SDWebImage

class BagCenterView: UIView {
    
    //MARK: - Properties
    let bagImageView = UIImageView()
    let addBtn = ButtonAnimation()
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension BagCenterView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        heightAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        //TODO: - BagImageView
        let iconW: CGFloat = screenWidth*(appDL.isIPhoneX ? 0.7 : 0.6)
        bagImageView.clipsToBounds = true
        //bagImageView.image = UIImage(named: "icon-bag")
        bagImageView.contentMode = .scaleAspectFill
        bagImageView.translatesAutoresizingMaskIntoConstraints = false
        bagImageView.widthAnchor.constraint(equalToConstant: iconW).isActive = true
        bagImageView.heightAnchor.constraint(equalToConstant: iconW).isActive = true
        
        //TODO: - AddBtn
        setupTitleForBtn(addBtn, txt: "Add Product".localized(), bgColor: defaultColor, fgColor: .white)
        addBtn.clipsToBounds = true
        addBtn.layer.cornerRadius = 25.0
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addBtn.widthAnchor.constraint(equalToConstant: screenWidth-40).isActive = true
        addBtn.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(bagImageView)
        stackView.addArrangedSubview(addBtn)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func updateUI(_ vc: UIViewController) {
        isHidden = false
        vc.view.addSubview(self)
        
        centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: vc.view.centerYAnchor, constant: -30.0).isActive = true
    }
    
    func downloadGIF() {
        if let url = Bundle.main.url(forResource: "bag.gif", withExtension: nil) {
            SDWebImageManager.shared.loadImage(
                with: url,
                options: [.continueInBackground],
                progress: nil) { image, data, _, _, _, _ in
                    self.bagImageView.image = image
                }
        }
    }
}
