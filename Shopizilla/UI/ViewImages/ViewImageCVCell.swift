//
//  ViewImageCVCell.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/05/2022.
//

import UIKit

class ViewImageCVCell: UICollectionViewCell {
    
    //MARK: - Properties
    static let id = "ViewImageCVCell"
    
    let coverImageView = UIImageView()
    let scrollView = UIScrollView()
    
    let bgView = UIView()
    var newFrame: CGRect = .zero
    var zoomImgView: UIImageView!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Configure

extension ViewImageCVCell {
    
    private func configureCell() {
        contentView.backgroundColor = .black
        backgroundColor = .black
        
        //TODO: - CoverImageView
        coverImageView.clipsToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(coverImageView)
        
        //TODO: - ZoomImage
        newFrame = coverImageView.superview!.convert(coverImageView.frame, to: nil)
        
        zoomImgView = UIImageView(frame: newFrame)
        zoomImgView.image = coverImageView.image
        zoomImgView.alpha = 0.0
        
        bgView.frame = bounds
        bgView.backgroundColor = .black
        bgView.alpha = 0.0
        
        //TODO: - ScrollView
        scrollView.frame = bounds
        scrollView.alpha = 0.0
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 6
        
        contentView.addSubview(bgView)
        contentView.addSubview(scrollView)
        scrollView.addSubview(zoomImgView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            coverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 1.0,
                       initialSpringVelocity: 1.0,
                       options: .curveEaseOut,
                       animations: {
            self.bgView.alpha = 1.0
            self.scrollView.alpha = 1.0
            self.zoomImgView.center = self.center
            self.zoomImgView.frame = CGRect(origin: .zero, size: self.frame.size)
            self.zoomImgView.contentMode = .scaleAspectFill
            self.coverImageView.isHidden = true
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.25) {
                self.zoomImgView.alpha = 1.0
            }
        })
    }
}

//MARK: - UIScrollViewDelegate

extension ViewImageCVCell: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return zoomImgView
    }
}
