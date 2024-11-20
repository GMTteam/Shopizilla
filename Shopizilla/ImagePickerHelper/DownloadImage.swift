//
//  DownloadImage.swift
//  Zilla NFTs
//
//  Created by Thanh Hoang on 17/11/2021.
//

import UIKit
import SDWebImage

class DownloadImage: NSObject {
    
    //MARK: - Properties
    static let shared = DownloadImage()
    
    override init() {
        super.init()
    }
}

//MARK: - Setups

extension DownloadImage {
    
    func downloadImage(link: String, contextSize: CGSize? = nil, completion: @escaping (UIImage?) -> Void) {
        let url = URL(string: link)
        let options: SDWebImageOptions = [.continueInBackground]
        var context: [SDWebImageContextOption: Any]? = nil
        
        if let contextSize = contextSize {
            let transform = SDImageResizingTransformer(size: contextSize, scaleMode: .aspectFill)
            context = [.imageTransformer: transform]
        }
        
        SDWebImageManager.shared.loadImage(with: url, options: options, context: context, progress: nil) { image, data, error, cacheType, finish, url in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    func batchDownloadImages(links: [String]) {
        let urls = links.compactMap({ URL(string: $0) })
        
        if urls.count > 0 {
            DispatchQueue.main.async {
                SDWebImagePrefetcher.shared.options = [.retryFailed, .lowPriority]
                SDWebImagePrefetcher.shared.prefetchURLs(urls)
            }
        }
    }
    
    func removeImageCache() {
        SDImageCache.shared.clearMemory()
        SDImageCache.shared.clearDisk()
    }
}
