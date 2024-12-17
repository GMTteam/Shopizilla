//
//  ShopViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 22/04/2022.
//

import UIKit
import Firebase

class ShopViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: ShopVC
    
    lazy var shops: [Shop] = []
    
    //MARK: - Initializes
    init(vc: ShopVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension ShopViewModel {
    
    func getShops() {
        Shop.fetchShops { shops in
            self.shops = shops
            
            let links = shops.map({ $0.bannerURL }).filter({ $0 != "" })
            DownloadImage.shared.batchDownloadImages(links: links)
            
            self.vc.reloadData()
            self.vc.hud?.removeHUD {}
        }
    }
}

//MARK: - SetupCell

extension ShopViewModel {
    
    func shopCell(_ cell: ShopCVCell, indexPath: IndexPath, cv: UICollectionView) {
        let model = shops[indexPath.item]
        cell.tag = indexPath.item
        
        DownloadImage.shared.downloadImage(link: model.bannerURL) { image in
            if cell.tag == indexPath.item {
                cell.bannerImageView.image = image
            }
        }
        
        cell.titleLbl.text = model.name
        //parallaxOffset(offsetY: cv.contentOffset.y, cell: cell)
    }
    
    private func parallaxOffset(offsetY: CGFloat, cell: ShopCVCell) -> CGFloat {
        return (offsetY - cell.frame.origin.y) / vc.parallaxHeight * vc.parallaxSpeed
    }
}
