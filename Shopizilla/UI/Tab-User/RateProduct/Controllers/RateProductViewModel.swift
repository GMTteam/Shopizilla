//
//  RateProductViewModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

class RateProductViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: RateProductVC
    
    //MARK: - Initializes
    init(vc: RateProductVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension RateProductViewModel {
    
    func getBanner() {
        
    }
}

//MARK: - SetupCell

extension RateProductViewModel {
    
    func rateCoverImageCVCell(_ cell: RateCoverImageCVCell, indexPath: IndexPath) {
        cell.coverImageView.image = vc.images[indexPath.item]
        cell.delegate = vc
        
        cell.setupCornerRadius(15.0)
    }
    
    func rateAddCoverImageCVCell(_ cell: RateAddCoverImageCVCell, indexPath: IndexPath) {
        let isBool = vc.images.count < 5
        let color: UIColor = isBool ? .gray : .lightGray.withAlphaComponent(0.5)
        
        cell.isUserInteractionEnabled = isBool
        cell.shape.strokeColor = color.cgColor
        cell.iconImageView.tintColor = color
    }
}
