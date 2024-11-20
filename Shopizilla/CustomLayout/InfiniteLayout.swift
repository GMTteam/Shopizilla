//
//  InfiniteLayout.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 16/04/2022.
//

import UIKit

class InfiniteLayout: UICollectionViewFlowLayout {
    
    private var velocityMultiplier: CGFloat = 1
    private let multiplier: CGFloat = 500.0
    private var contentSize: CGSize = .zero
    private var hasValidLayout: Bool = false
    public var isScale = true
    
    public var isEnabled: Bool = true {
        didSet { self.invalidateLayout() }
    }
    
    var currentPage: CGPoint {
        guard let collectionView = self.collectionView else { return .zero }
        return page(for: collectionView.contentOffset)
    }
    
    static var minimumContentSize: CGFloat {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) * 5
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public convenience init(layout: UICollectionViewLayout) {
        self.init()
        guard let layout = layout as? UICollectionViewFlowLayout else { return }
        scrollDirection = layout.scrollDirection
        minimumLineSpacing = layout.minimumLineSpacing
        minimumInteritemSpacing = layout.minimumInteritemSpacing
        itemSize = layout.itemSize
        sectionInset = layout.sectionInset
        headerReferenceSize = layout.headerReferenceSize
        footerReferenceSize = layout.footerReferenceSize
    }
    
    override open func prepare() {
        let collectionViewContentSize = super.collectionViewContentSize
        contentSize = CGSize(width: collectionViewContentSize.width,
                             height: collectionViewContentSize.height)
        hasValidLayout = {
            guard let cv = self.collectionView, cv.bounds != .zero, isEnabled else {
                return false
            }
            
            return (scrollDirection == .horizontal ? contentSize.width : contentSize.height) >=
            InfiniteLayout.minimumContentSize
        }()
        
        super.prepare()
    }
    
    override var collectionViewContentSize: CGSize {
        guard hasValidLayout else { return contentSize }
        let width = contentSize.width
        let height = contentSize.height
        let w: CGFloat = scrollDirection == .horizontal ? width * multiplier : width
        let h: CGFloat = scrollDirection == .vertical ? height * multiplier : height
        return CGSize(width: w, height: h)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
        return layoutAttributes(from: attributes, page: currentPage)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard hasValidLayout else { return super.layoutAttributesForElements(in: rect) }
        
        let page = self.page(for: rect.origin)
        var elements = [UICollectionViewLayoutAttributes]()
        var rect = self.rect(from: rect)
        if (scrollDirection == .horizontal && rect.maxX > contentSize.width) ||
            (scrollDirection == .vertical && rect.maxY > contentSize.height)
        {
            let w: CGFloat = scrollDirection == .horizontal ? rect.maxX - contentSize.width : rect.width
            let h: CGFloat = scrollDirection == .vertical ? rect.maxY - contentSize.height : rect.height
            let size = CGSize(width: w, height: h)
            let diffRect = CGRect(origin: .zero, size: size)
            elements.append(contentsOf: self.elements(in: diffRect, page: self.page(from: page, offset: 1)))
            
            if self.scrollDirection == .horizontal {
                rect.size.width -= diffRect.width
                
            } else {
                rect.size.height -= diffRect.height
            }
        }
        
        elements.append(contentsOf: self.elements(in: rect, page: page))
        
        if isScale {
            for attributes in elements {
                let i: CGFloat = 0.9
                let center = collectionView!.bounds.size.width/2.0
                let offset = collectionView!.contentOffset.x
                let normalizedCenter = attributes.center.x - offset
                let maxDistance = itemSize.width + minimumLineSpacing
                let distanceFromCenter = min(abs(center - normalizedCenter), maxDistance)
                let ratio = (maxDistance - distanceFromCenter)/maxDistance
                let scale = ratio * (1 - i) + i
                let identity = CATransform3DIdentity
                attributes.transform3D = CATransform3DScale(identity, scale, scale, 1.0)
            }
        }
        
        return elements
    }
    
    private func page(for point: CGPoint) -> CGPoint {
        let xPage: CGFloat = floor(point.x / contentSize.width)
        let yPage: CGFloat = floor(point.y / contentSize.height)
        
        let x: CGFloat = self.scrollDirection == .horizontal ? xPage : 0
        let y: CGFloat = self.scrollDirection == .vertical ? yPage : 0
        
        return CGPoint(x: x, y: y)
    }
    
    private func page(from page: CGPoint, offset: CGFloat) -> CGPoint {
        let x: CGFloat = self.scrollDirection == .horizontal ? page.x + offset : page.x
        let y: CGFloat = self.scrollDirection == .vertical ? page.y + offset : page.y
        return CGPoint(x: x, y: y)
    }
    
    private func pageIndex(from page: CGPoint) -> CGFloat {
        return self.scrollDirection == .horizontal ? page.x : page.y
    }
    
    private func rect(from rect: CGRect, page: CGPoint = .zero) -> CGRect {
        var rect = rect
        if self.scrollDirection == .horizontal && rect.origin.x < 0 {
            rect.origin.x += abs(floor(contentSize.width / rect.origin.x)) * contentSize.width
            
        } else if self.scrollDirection == .vertical && rect.origin.y < 0 {
            rect.origin.y += abs(floor(contentSize.height / rect.origin.y)) * contentSize.height
        }
        rect.origin.x = rect.origin.x.truncatingRemainder(dividingBy: contentSize.width)
        rect.origin.y = rect.origin.y.truncatingRemainder(dividingBy: contentSize.height)
        rect.origin.x += page.x * contentSize.width
        rect.origin.y += page.y * contentSize.height
        return rect
    }
    
    private func elements(in rect: CGRect, page: CGPoint) -> [UICollectionViewLayoutAttributes] {
        let rect = self.rect(from: rect)
        let elements = super.layoutAttributesForElements(in: rect)?
            .map { self.layoutAttributes(from: $0, page: page) }
            .filter { $0 != nil }
            .map { $0! } ?? []
        return elements
    }
    
    private func layoutAttributes(from layoutAttributes: UICollectionViewLayoutAttributes, page: CGPoint) -> UICollectionViewLayoutAttributes! {
        guard let attributes = self.copyLayoutAttributes(layoutAttributes) else { return nil }
        attributes.frame = rect(from: attributes.frame, page: page)
        return attributes
    }
    
    // MARK: Loop
    private func updateContentOffset(_ offset: CGPoint) {
        guard let collectionView = self.collectionView else { return }
        collectionView.contentOffset = offset
        collectionView.layoutIfNeeded()
    }
    
    private func preferredContentOffset(forContentOffset contentOffset: CGPoint) -> CGPoint {
        return rect(from: CGRect(origin: contentOffset, size: .zero),
                    page: self.page(from: .zero, offset: multiplier / 2)).origin
    }
    
    public func loopCollectionViewIfNeeded() {
        guard let collectionView = self.collectionView, self.hasValidLayout else { return }
        let page = self.pageIndex(from: self.page(for: collectionView.contentOffset))
        let offset = self.preferredContentOffset(forContentOffset: collectionView.contentOffset)
        if (page < 2 || page > self.multiplier - 2) &&
            collectionView.contentOffset != offset {
            self.updateContentOffset(offset)
        }
    }
    
    // MARK: Paging
    private func collectionViewRect() -> CGRect? {
        guard let collectionView = self.collectionView else { return nil }
        let margins = UIEdgeInsets(top: collectionView.contentInset.top + collectionView.layoutMargins.top,
                                   left: collectionView.contentInset.left + collectionView.layoutMargins.left,
                                   bottom: collectionView.contentInset.bottom + collectionView.layoutMargins.bottom,
                                   right: collectionView.contentInset.right + collectionView.layoutMargins.right)
        
        var visibleRect = CGRect()
        visibleRect.origin.x = margins.left
        visibleRect.origin.y = margins.top
        visibleRect.size.width = collectionView.bounds.width - visibleRect.origin.x - margins.right
        visibleRect.size.height = collectionView.bounds.height - visibleRect.origin.y - margins.bottom
        return visibleRect
    }
    
    private func visibleLayoutAttributes(at offset: CGPoint? = nil) -> [UICollectionViewLayoutAttributes] {
        guard let collectionView = self.collectionView else { return [] }
        return (self.layoutAttributesForElements(in: CGRect(origin: offset ?? collectionView.contentOffset, size: collectionView.frame.size)) ?? [])
            .sorted(by: { lhs, rhs in
                guard let lhs = self.centeredContentOffset(forRect: lhs.frame) else { return false }
                guard let rhs = self.centeredContentOffset(forRect: rhs.frame) else { return true }
                let value: (CGPoint)->CGFloat = {
                    return self.scrollDirection == .horizontal ?
                        abs(collectionView.contentOffset.x - $0.x) : abs(collectionView.contentOffset.y - $0.y)
                }
                return value(lhs) < value(rhs)
            })
    }
    
    private func preferredVisibleLayoutAttributes(at offset: CGPoint? = nil, velocity: CGPoint = .zero, targetOffset: CGPoint? = nil, indexPath: IndexPath? = nil) -> UICollectionViewLayoutAttributes? {
        guard let currentOffset = self.collectionView?.contentOffset else { return nil }
        let direction: (CGPoint)->Bool = {
            return self.scrollDirection == .horizontal ? $0.x > currentOffset.x : $0.y > currentOffset.y
        }
        
        let velocity = self.scrollDirection == .horizontal ? velocity.x : velocity.y
        let targetDirection = direction(targetOffset ?? currentOffset)
        let attributes = self.visibleLayoutAttributes(at: offset)
        if let indexPath = indexPath,
            let attributes = attributes.first(where: { $0.indexPath == indexPath }) {
            return attributes
        }
        
        return attributes
            .first { attributes in
                guard let offset = self.centeredContentOffset(forRect: attributes.frame) else { return false }
                return direction(offset) == targetDirection || velocity == 0
        }
    }
    
    private func centeredContentOffset(forRect rect: CGRect) -> CGPoint? {
        guard let collectionView = self.collectionView,
            let collectionRect = self.collectionViewRect() else { return nil }
        return CGPoint(x: self.scrollDirection == .horizontal ? abs(rect.midX - collectionRect.origin.x - collectionRect.width/2) : collectionView.contentOffset.x,
                       y: self.scrollDirection == .vertical ? abs(rect.midY - collectionRect.origin.y - collectionRect.height/2) : collectionView.contentOffset.y)
    }
    
    public func centerCollectionView(withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = self.collectionView, self.hasValidLayout else { return }
        let newTarget = CGPoint(x: self.scrollDirection == .horizontal ?
            collectionView.contentOffset.x + velocity.x * velocityMultiplier :
            targetContentOffset.pointee.x,
                                y: self.scrollDirection == .vertical ?
                                    collectionView.contentOffset.y + velocity.y * velocityMultiplier :
                                    targetContentOffset.pointee.y)
        
        guard let preferredAttributes = self.preferredVisibleLayoutAttributes(
            at: newTarget,
            velocity: velocity,
            targetOffset: targetContentOffset.pointee),
            let offset =  self.centeredContentOffset(forRect: preferredAttributes.frame) else { return }
        
        targetContentOffset.pointee = offset
    }
    
    public func centerCollectionViewIfNeeded(indexPath: IndexPath? = nil) {
        guard let collectionView = self.collectionView, self.hasValidLayout else { return }
        guard let preferredAttributes = self.preferredVisibleLayoutAttributes(indexPath: indexPath),
            let offset = self.centeredContentOffset(forRect: preferredAttributes.frame),
            collectionView.contentOffset != offset else { return }
        self.updateContentOffset(offset)
    }
    
    // MARK: Copy
    public func copyLayoutAttributes(_ attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes? {
        return attributes.copy() as? UICollectionViewLayoutAttributes
    }
}
