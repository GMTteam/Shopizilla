//
//  ProductBottomView.swift
//  Shopizilla
//
//  Created by Anh Tu on 24/04/2022.
//

import UIKit

class ProductBottomView: UIView {
    
    //MARK: - Properties
    let addView = UIView()
    let addBtn = ButtonAnimation()
    
    let oldPriceLbl = UILabel()
    let newPriceLbl = UILabel()
    
    let plusView = UIView()
    let plusBtn = ButtonAnimation()
    
    let numLbl = UILabel()
    
    let minusView = UIView()
    let minusBtn = ButtonAnimation()
    
    private let bagW = screenWidth
    private var bagH: CGFloat {
        return bagW * (200/1000)
    }
    
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

extension ProductBottomView {
    
    private func setupViews() {
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        heightAnchor.constraint(equalToConstant: bagH).isActive = true
        widthAnchor.constraint(equalToConstant: bagW).isActive = true
        
        setupBezierPath()
        shadow()
        
        //TODO: - OldPriceLbl
        oldPriceLbl.font = UIFont(name: FontName.ppMedium, size: 19.0)
        oldPriceLbl.textColor = .gray
        oldPriceLbl.minimumScaleFactor = 0.8
        oldPriceLbl.adjustsFontSizeToFitWidth = true
        oldPriceLbl.translatesAutoresizingMaskIntoConstraints = false
        oldPriceLbl.widthAnchor.constraint(equalToConstant: (screenWidth-bagH)/2-30).isActive = true
        
        //TODO: - NewPriceLbl
        newPriceLbl.font = UIFont(name: FontName.ppSemiBold, size: 25.0)
        newPriceLbl.textColor = defaultColor
        newPriceLbl.minimumScaleFactor = 0.8
        newPriceLbl.adjustsFontSizeToFitWidth = true
        newPriceLbl.translatesAutoresizingMaskIntoConstraints = false
        newPriceLbl.widthAnchor.constraint(equalToConstant: (screenWidth-bagH)/2-30).isActive = true
        
        //TODO: - UIStackView
        let priceSV = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .leading)
        priceSV.addArrangedSubview(oldPriceLbl)
        priceSV.addArrangedSubview(newPriceLbl)
        addSubview(priceSV)
        
        //TODO: - PlusBtn
        setupBtn(plusView, plusBtn, imgName: "icon-plus", tag: 4)
        
        //TODO: - NumLbl
        let parW: CGFloat = ((screenWidth-bagH)/2-40-20)/3
        numLbl.font = UIFont(name: FontName.ppSemiBold, size: 20.0)
        numLbl.textColor = .darkGray
        numLbl.textAlignment = .center
        numLbl.adjustsFontSizeToFitWidth = true
        numLbl.minimumScaleFactor = 0.8
        numLbl.translatesAutoresizingMaskIntoConstraints = false
        numLbl.widthAnchor.constraint(equalToConstant: parW).isActive = true
        numLbl.heightAnchor.constraint(equalToConstant: parW).isActive = true
        
        //TODO: - MinusBtn
        setupBtn(minusView, minusBtn, imgName: "icon-minus", tag: 5)
        
        //TODO: - UIStackView
        let btnSV = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        btnSV.addArrangedSubview(plusView)
        btnSV.addArrangedSubview(numLbl)
        btnSV.addArrangedSubview(minusView)
        addSubview(btnSV)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            priceSV.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
            priceSV.topAnchor.constraint(equalTo: topAnchor, constant: 5.0),
            
            btnSV.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
            btnSV.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
        ])
        
        setupHidden(true)
    }
    
    private func setupBezierPath() {
        let maxW: CGFloat = 1000
        let maxH: CGFloat = 200
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: bagW*(688.57/maxW), y: 0))
        bezierPath.addCurve(to: CGPoint(x: bagW*(602.09/maxW), y: bagH*(53.06/maxH)),
                            controlPoint1: CGPoint(x: bagW*(652.05/maxW), y: 0),
                            controlPoint2: CGPoint(x: bagW*(618.97/maxW), y: bagH*(20.68/maxH)))
        bezierPath.addCurve(to: CGPoint(x: bagW*(580.5/maxW), y: bagH*(82.13/maxH)),
                            controlPoint1: CGPoint(x: bagW*(596.56/maxW), y: bagH*(63.68/maxH)),
                            controlPoint2: CGPoint(x: bagW*(589.31/maxW), y: bagH*(73.48/maxH)))
        bezierPath.addCurve(to: CGPoint(x: bagW*(501.13/maxW), y: bagH*(114.99/maxH)),
                            controlPoint1: CGPoint(x: bagW*(559.34/maxW), y: bagH*(102.88/maxH)),
                            controlPoint2: CGPoint(x: bagW*(530.77/maxW), y: bagH*(114.71/maxH)))
        bezierPath.addCurve(to: CGPoint(x: bagW*(418.68/maxW), y: bagH*(81.32/maxH)),
                            controlPoint1: CGPoint(x: bagW*(469.99/maxW), y: bagH*(115.29/maxH)),
                            controlPoint2: CGPoint(x: bagW*(440.67/maxW), y: bagH*(103.31/maxH)))
        bezierPath.addCurve(to: CGPoint(x: bagW*(397.52/maxW), y: bagH*(52.3/maxH)),
                            controlPoint1: CGPoint(x: bagW*(410.03/maxW), y: bagH*(72.67/maxH)),
                            controlPoint2: CGPoint(x: bagW*(402.93/maxW), y: bagH*(62.88/maxH)))
        bezierPath.addCurve(to: CGPoint(x: bagW*(311.44/maxW), y: 0),
                            controlPoint1: CGPoint(x: bagW*(381.02/maxW), y: bagH*(20.07/maxH)),
                            controlPoint2: CGPoint(x: bagW*(347.64/maxW), y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: bagH))
        bezierPath.addLine(to: CGPoint(x: bagW, y: bagH))
        bezierPath.addLine(to: CGPoint(x: bagW, y: 0))
        bezierPath.addLine(to: CGPoint(x: bagW*(688.57/maxW), y: 0))
        bezierPath.close()
        
        let shape = CAShapeLayer()
        shape.path = bezierPath.cgPath
        shape.fillColor = UIColor.white.cgColor
        shape.strokeColor = UIColor.clear.cgColor
        shape.lineWidth = 1.0
        
        layer.addSublayer(shape)
    }
    
    private func shadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: -0.5)
        layer.shadowRadius = 1.5
        layer.shadowOpacity = 0.15
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    private func setupBtn(_ parentView: UIView, _ btn: ButtonAnimation, imgName: String, tag: Int) {
        let parW: CGFloat = ((screenWidth-bagH)/2-40-20)/3
        
        parentView.clipsToBounds = true
        parentView.backgroundColor = .white
        parentView.layer.cornerRadius = parW/2
        parentView.translatesAutoresizingMaskIntoConstraints = false
        
        parentView.widthAnchor.constraint(equalToConstant: parW).isActive = true
        parentView.heightAnchor.constraint(equalToConstant: parW).isActive = true
        
        setupShadow(parentView, radius: 1.0, opacity: 0.1)
        
        btn.setImage(UIImage(named: imgName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = defaultColor
        btn.clipsToBounds = true
        btn.backgroundColor = .white
        btn.layer.cornerRadius = parW/2
        btn.tag = tag
        btn.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(btn)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            btn.topAnchor.constraint(equalTo: parentView.topAnchor),
            btn.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            btn.trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
            btn.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
        ])
    }
    
    func setupAddView() {
        addView.clipsToBounds = true
        addView.backgroundColor = .white
        addView.layer.cornerRadius = bagH/2
        addView.translatesAutoresizingMaskIntoConstraints = false
        setupShadow(addView)
        
        NSLayoutConstraint.activate([
            addView.widthAnchor.constraint(equalToConstant: bagH),
            addView.heightAnchor.constraint(equalToConstant: bagH),
            addView.centerYAnchor.constraint(equalTo: topAnchor),
            addView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setupAddBtn() {
        addBtn.setImage(UIImage(named: "icon-bag-")?.withRenderingMode(.alwaysTemplate), for: .normal)
        addBtn.tintColor = .white
        addBtn.backgroundColor = defaultColor
        addBtn.clipsToBounds = true
        addBtn.layer.cornerRadius = bagH/2
        addBtn.translatesAutoresizingMaskIntoConstraints = false
        addView.addSubview(addBtn)
        
        NSLayoutConstraint.activate([
            addBtn.widthAnchor.constraint(equalToConstant: bagH),
            addBtn.heightAnchor.constraint(equalToConstant: bagH),
            addBtn.centerYAnchor.constraint(equalTo: addBtn.centerYAnchor),
            addBtn.centerXAnchor.constraint(equalTo: addBtn.centerXAnchor),
        ])
    }
    
    func setupHidden(_ setHidden: Bool) {
        isHidden = setHidden
        addView.isHidden = setHidden
        addBtn.isHidden = setHidden
    }
    
    func updatePrice(_ product: Product) {
        let oldPrice = product.price
        let perc = (100 - product.saleOff)/100
        let newPrice = (oldPrice*perc)
        
        oldPriceLbl.text = ""
        oldPriceLbl.attributedText = nil

        if product.saleOff != 0.0 {
            let att: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: FontName.ppMedium, size: 19.0)!,
                .foregroundColor: UIColor.gray,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            let attr = NSMutableAttributedString(string: oldPrice.formattedCurrency, attributes: att)

            oldPriceLbl.attributedText = attr
        }

        oldPriceLbl.isHidden = product.saleOff == 0.0
        newPriceLbl.text = newPrice.formattedCurrency
    }
}
