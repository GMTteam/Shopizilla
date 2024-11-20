//
//  GenderTVCell.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 11/12/2021.
//

import UIKit

protocol GenderTVCellDelegate: AnyObject {
    func checkDidTap(_ cell: GenderTVCell, genderTxt: String)
}

class GenderTVCell: UITableViewCell {
    
    //MARK: - Properties
    static let id = "GenderTVCell"
    weak var delegate: GenderTVCellDelegate?
    
    let maleView = UIView()
    let femaleView = UIView()
    
    let circleMaleView = UIView()
    let circleFemaleView = UIView()
    
    let checkMaleView = UIView()
    let checkFemaleView = UIView()
    
    let maleLbl = UILabel()
    let femaleLbl = UILabel()
    
    let maleBtn = ButtonAnimation()
    let femaleBtn = ButtonAnimation()
    
    var isMale = false {
        didSet {
            checkMaleView.isHidden = !isMale
            checkFemaleView.isHidden = isMale
        }
    }
    
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

extension GenderTVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        selectionStyle = .none
        
        //TODO: - MaleView
        setupGenderView(maleView)
        
        //TODO: - FemaleView
        setupGenderView(femaleView)
        
        //TODO: - StackView
        let stackView = createStackView(spacing: 20.0, distribution: .fillEqually, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(maleView)
        stackView.addArrangedSubview(femaleView)
        contentView.addSubview(stackView)
        
        //TODO: - CircleMaleCheckView
        setupCircleView(circleMaleView)
        
        //TODO: - CircleFemaleCheckView
        setupCircleView(circleFemaleView)
        
        //TODO: - MaleLbl
        maleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        maleLbl.text = "Male".localized()
        maleLbl.textColor = .black
        
        //TODO: - FemaleLbl
        femaleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        femaleLbl.text = "Female".localized()
        femaleLbl.textColor = .black
        
        //TODO: - StackView
        let maleSV = createCircleSV()
        maleSV.addArrangedSubview(circleMaleView)
        maleSV.addArrangedSubview(maleLbl)
        maleView.addSubview(maleSV)
        
        //TODO: - StackView
        let femaleSV = createCircleSV()
        femaleSV.addArrangedSubview(circleFemaleView)
        femaleSV.addArrangedSubview(femaleLbl)
        femaleView.addSubview(femaleSV)
        
        //TODO: - CheckMaleView
        setupCheckView(checkMaleView)
        circleMaleView.addSubview(checkMaleView)
        
        //TODO: - CheckFemaleView
        setupCheckView(checkFemaleView)
        circleFemaleView.addSubview(checkFemaleView)
        
        //TODO: - MaleBtn
        setupCheckBtn(maleBtn, tag: 1, view: maleView)
        
        //TODO: - FemaleBtn
        setupCheckBtn(femaleBtn, tag: 2, view: femaleView)
        
        //TODO: - NSLayoutConstraint
        let sp: CGFloat = 15.0
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            maleSV.centerYAnchor.constraint(equalTo: maleView.centerYAnchor),
            maleSV.leadingAnchor.constraint(equalTo: maleView.leadingAnchor, constant: sp),
            maleSV.trailingAnchor.constraint(equalTo: maleView.trailingAnchor, constant: -sp),
            
            femaleSV.centerYAnchor.constraint(equalTo: femaleView.centerYAnchor),
            femaleSV.leadingAnchor.constraint(equalTo: femaleView.leadingAnchor, constant: sp),
            femaleSV.trailingAnchor.constraint(equalTo: femaleView.trailingAnchor, constant: -sp),
            
            checkMaleView.centerXAnchor.constraint(equalTo: circleMaleView.centerXAnchor),
            checkMaleView.centerYAnchor.constraint(equalTo: circleMaleView.centerYAnchor),
            
            checkFemaleView.centerXAnchor.constraint(equalTo: circleFemaleView.centerXAnchor),
            checkFemaleView.centerYAnchor.constraint(equalTo: circleFemaleView.centerYAnchor),
        ])
    }
    
    private func setupGenderView(_ genderView: UIView) {
        let width: CGFloat = (screenWidth-60)*0.5
        let height: CGFloat = 60.0
        
        genderView.clipsToBounds = true
        genderView.layer.cornerRadius = height/2
        genderView.layer.borderWidth = 1.0
        genderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        genderView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        genderView.translatesAutoresizingMaskIntoConstraints = false
        genderView.widthAnchor.constraint(equalToConstant: width).isActive = true
        genderView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    private func setupCircleView(_ circleView: UIView) {
        let width: CGFloat = 20.0
        
        circleView.clipsToBounds = true
        circleView.layer.cornerRadius = width/2
        circleView.layer.borderWidth = 0.5
        circleView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        circleView.backgroundColor = .white
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.widthAnchor.constraint(equalToConstant: width).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    private func createCircleSV() -> UIStackView {
        let sv = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        return sv
    }
    
    private func setupCheckView(_ checkView: UIView) {
        let width: CGFloat = 20*0.6
        
        checkView.clipsToBounds = true
        checkView.layer.cornerRadius = width/2
        checkView.isHidden = true
        checkView.backgroundColor = defaultColor
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.widthAnchor.constraint(equalToConstant: width).isActive = true
        checkView.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    private func setupCheckBtn(_ btn: ButtonAnimation, tag: Int, view: UIView) {
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 30.0
        btn.backgroundColor = .clear
        btn.tag = tag
        btn.delegate = self
        contentView.addSubview(btn)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        btn.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

//MARK: - ButtonAnimationDelegate

extension GenderTVCell: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        var txt = "Male"
        
        if sender.tag == 1 {
            isMale = false
            txt = "Male".localized()
            
        } else if sender.tag == 2 {
            isMale = true
            txt = "Female".localized()
        }
        
        delegate?.checkDidTap(self, genderTxt: txt)
    }
}
