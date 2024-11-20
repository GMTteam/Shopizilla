//
//  PHFetchResult+Ext.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 17/03/2022.
//

import Foundation
import Photos

internal extension PHFetchResult where ObjectType == PHAsset {
    
    func assetsAtIndexPaths(_ indexPaths: [IndexPath]) -> [PHAsset] {
        if indexPaths.count == 0 { return [] }
        
        var assets: [PHAsset] = []
        assets.reserveCapacity(indexPaths.count)
        
        for indexPath in indexPaths {
            let asset = self[indexPath.item]
            assets.append(asset)
        }
        
        return assets
    }
}
