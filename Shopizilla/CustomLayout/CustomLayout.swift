//
//  CustomLayout.swift
//  Shopizilla
//
//  Created by Anh Tu on 17/04/2022.
//

import UIKit

public struct SpacingMode {
    public var horizontal: CGFloat
    public var vertical: CGFloat
    
    public init(horizontal: CGFloat = 0.0, vertical: CGFloat = 0.0) {
        self.horizontal = horizontal
        self.vertical = vertical
    }
    
    public static var zero: SpacingMode {
        return SpacingMode()
    }
}

public enum ContentAlign {
    case left
    case right
}

protocol CustomLayoutDelegate: AnyObject {
    func cellSize(_ indexPath: IndexPath, cv: UICollectionView) -> CGSize
}

class CustomLayout: UICollectionViewFlowLayout {
    
    public var contentPadding: SpacingMode = .zero
    public var contentAlign: ContentAlign = .left
    public var cellPadding: CGFloat = 0.0
    
    public var cache: [UICollectionViewLayoutAttributes] = []
    public var contentSize: CGSize = .zero
    
    public weak var delegate: CustomLayoutDelegate?
    
    override var collectionViewContentSize: CGSize {
        return contentSize
    }
    
    override func prepare() {
        super.prepare()
        cache.removeAll()
        calculateCellFrame()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    public func calculateCellFrame() {}
}
