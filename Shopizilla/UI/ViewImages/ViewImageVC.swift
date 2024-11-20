//
//  ViewImageVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/05/2022.
//

import UIKit

class ViewImageVC: UIViewController {
    
    //MARK: - Properties
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let cancelBtn = ButtonAnimation()
    
    var index = 0
    lazy var imageLinks: [String] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
}

//MARK: - Setups

extension ViewImageVC {
    
    private func setupViews() {
        view.backgroundColor = .black
        
        //TODO: - CollectionView
        collectionView.setupCollectionView(.black)
        collectionView.isPagingEnabled = true
        collectionView.decelerationRate = .fast
        collectionView.register(ViewImageCVCell.self, forCellWithReuseIdentifier: ViewImageCVCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.setupLayout(scrollDirection: .horizontal, lineSpacing: 0.0, itemSpacing: 0.0)
        collectionView.setupConstraint(superView: view)
        
        //TODO: - CancelBtn
        let cancelAttr = createMutableAttributedString(fgColor: .black, txt: "Cancel".localized())
        cancelBtn.setAttributedTitle(cancelAttr, for: .normal)
        cancelBtn.backgroundColor = .white
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 25.0
        cancelBtn.delegate = self
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cancelBtn)
        
        NSLayoutConstraint.activate([
            cancelBtn.widthAnchor.constraint(equalToConstant: screenWidth-40),
            cancelBtn.heightAnchor.constraint(equalToConstant: 50.0),
            cancelBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20.0)
        ])
    }
}

//MARK: - UICollectionViewDataSource

extension ViewImageVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageLinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewImageCVCell.id, for: indexPath) as! ViewImageCVCell
        let link = imageLinks[indexPath.item]
        
        cell.tag = indexPath.item
        
        DownloadImage.shared.downloadImage(link: link) { image in
            if cell.tag == indexPath.item {
                cell.zoomImgView.image = image
            }
        }
        
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension ViewImageVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ViewImageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenWidth, height: screenWidth*imageHeightRatio)
    }
}

//MARK: - ButtonAnimationDelegate

extension ViewImageVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        dismiss(animated: true)
    }
}
