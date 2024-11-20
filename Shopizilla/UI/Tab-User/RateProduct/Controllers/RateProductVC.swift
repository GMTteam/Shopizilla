//
//  RateProductVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 04/05/2022.
//

import UIKit

protocol RateProductVCDelegate: AnyObject {
    func rateDidTap(vc: RateProductVC)
}

class RateProductVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: RateProductVCDelegate?
    
    let separatorView = UIView()
    private let scrollView = RateProductScrollView()
    
    private var containerView: RateProductContainerView { return scrollView.containerView }
    
    private var productView: RateProductView { return containerView.productView }
    private var starView: RateProductStarView { return containerView.starView }
    private var desView: RateProductDesView { return containerView.desView }
    private var coverView: RateProductCoverView { return containerView.coverView }
    private var submitView: RateProductSubmitView { return containerView.submitView }
    
    private var coverCV: UICollectionView { return coverView.collectionView }
    
    var shopping: ShoppingCart?
    
    private var rating = 0
    private var desTxt = ""
    var images: [UIImage?] = []
    
    private let limit = 100
    private let placeholderTxt = "Would you like to write anything about this product?".localized()
    
    private var photoAlertVC: PhotoAlertVC?
    private var imagePickerHelper: ImagePickerHelper?
    
    private var willShowObs: Any?
    private var willHideObs: Any?
    
    private var viewModel: RateProductViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if let shopping = shopping {
            productView.updateUI(shopping)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: willShowObs)
        removeObserverBy(observer: willHideObs)
    }
}

//MARK: - Setups

extension RateProductVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Rate Product".localized()
        
        viewModel = RateProductViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - ScrollView
        scrollView.setupViews(self, dl: self)
        
        starView.rateStackView.delegate = self
        
        desView.textView.delegate = self
        desView.textView.text = placeholderTxt
        desView.textView.addDoneBtn(target: self, selector: #selector(doneDidTap))
        
        desView.numLbl.text = "\(limit)" + " " + "characters".localized()
        
        coverView.setupDataSourceAndDelegate(dl: self)
        
        submitView.submitBtn.delegate = self
        submitView.submitBtn.tag = 0
        submitView.submitBtn.isUserInteractionEnabled = false
        submitView.submitBtn.alpha = 0.2
    }
    
    @objc private func doneDidTap() {
        desView.textView.resignFirstResponder()
    }
}

//MARK: - Add Observer

extension RateProductVC {
    
    private func addObserver() {
        willShowObs = NotificationCenter.default.addObserver(forName: .keyboardWillShow, object: nil, queue: nil) { notif in
            if let height = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
               let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.scrollView.contentInset.bottom = height
                    self.view.layoutIfNeeded()
                }
            }
        }
        willHideObs = NotificationCenter.default.addObserver(forName: .keyboardWillHide, object: nil, queue: nil) { notif in
            if let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.scrollView.contentInset.bottom = 0.0
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension RateProductVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Submit Review
            guard rating != 0 else {
                return
            }
            guard let shopping = shopping else {
                return
            }
            desView.textView.resignFirstResponder()
            
            let hud = HUD.hud(kWindow)
            let productUID = (shopping.category + "-" + shopping.prID).uppercased()
            var model = ReviewModel(productUID: productUID,
                                    productID: shopping.prID,
                                    category: shopping.category,
                                    subcategory: shopping.subcategory,
                                    rating: rating,
                                    description: desTxt,
                                    imageURLs: [],
                                    orderID: shopping.orderID)
            
            //Nếu có hình ảnh.
            //Lưu hình ảnh lên Storage trước.
            //Sau đó cập nhật cho Firestore.
            if images.count != 0 {
                var imageURLs: [String] = []
                var i = 0
                
                images.forEach({
                    let store = FirebaseStorage(image: $0)
                    store.saveReview { link in
                        if let link = link {
                            imageURLs.append(link)
                        }
                        
                        if i == self.images.count-1 {
                            model.imageURLs = imageURLs
                            
                            let review = Review(model: model)
                            review.saveReview {
                                hud.removeHUD {}
                                self.delegate?.rateDidTap(vc: self)
                            }
                            
                            if let currentUser = appDL.currentUser {
                                currentUser.updateCoin(coin: 25.0) {}
                            }
                            
                            shopping.updateShoppingCart(dict: ["isReview": true]) {
                                NotificationCenter.default.post(name: .shoppingCartKey, object: nil)
                            }
                        }
                        
                        i += 1
                    }
                })
                
            } else {
                //Nếu ko hình ảnh.
                let review = Review(model: model)
                review.saveReview {
                    hud.removeHUD {}
                    self.delegate?.rateDidTap(vc: self)
                }
                
                if let currentUser = appDL.currentUser {
                    currentUser.updateCoin(coin: 25.0) {}
                }
                
                shopping.updateShoppingCart(dict: ["isReview": true]) {
                    NotificationCenter.default.post(name: .shoppingCartKey, object: nil)
                }
            }
        }
    }
}

//MARK: - RateStackViewDelegate

extension RateProductVC: RateStackViewDelegate {
    
    func rateDidTap(_ rating: Int) {
        self.desView.textView.resignFirstResponder()
        self.rating = rating
        
        submitView.submitBtn.isUserInteractionEnabled = rating != 0
        submitView.submitBtn.alpha = rating != 0 ? 1.0 : 0.2
    }
}

//MARK: - UIScrollViewDelegate

extension RateProductVC: UIScrollViewDelegate {}

//MARK: - UITextViewDelegate

extension RateProductVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {}
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderTxt {
            textView.text = ""
            textView.textColor = .black
        }
        
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = placeholderTxt
            textView.textColor = .placeholderText
        }
        
        textView.resignFirstResponder()
        
        if let text = textView.text,
            text != placeholderTxt,
            !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            desTxt = text
            
        } else {
            desTxt = ""
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let kText = textView.text, let range = Range(range, in: kText) else {
            return false
        }
        let subStr = kText[range]
        let count = kText.count - subStr.count + text.count
        
        var num = limit - count
        num = num <= 0 ? 0 : num
        
        let txt = num > 1 ? (" " + "characters".localized()) : (" " + "character".localized())
        desView.numLbl.text = "\(num)" + txt
        
        return count < limit
    }
}

//MARK: - UICollectionViewDataSource

extension RateProductVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? images.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateCoverImageCVCell.id, for: indexPath) as! RateCoverImageCVCell
            viewModel.rateCoverImageCVCell(cell, indexPath: indexPath)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateAddCoverImageCVCell.id, for: indexPath) as! RateAddCoverImageCVCell
            viewModel.rateAddCoverImageCVCell(cell, indexPath: indexPath)
            return cell
        }
    }
}

//MARK: - UICollectionViewDelegate

extension RateProductVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("CoverImage")
            
        } else {
            guard images.count < 5 else {
                return
            }
            desView.textView.resignFirstResponder()
            
            photoAlertVC?.removeFromParent()
            photoAlertVC?.view.removeFromSuperview()
            photoAlertVC = nil
            
            photoAlertVC = PhotoAlertVC()
            photoAlertVC!.view.frame = kWindow.bounds
            photoAlertVC!.delegate = self
            kWindow.addSubview(photoAlertVC!.view)
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension RateProductVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return section == 0 ? .zero : CGSize(width: 10.0, height: 80.0)
    }
}

//MARK: - PhotoAlertVCDelegate

extension RateProductVC: PhotoAlertVCDelegate {
    
    func takePhoto() {
        imagePickerHelper = ImagePickerHelper(vc: self, isTakePhoto: true, completion: { image in
            self.addSquareImage(image)
        })
    }
    
    func photoFromLibrary() {
        imagePickerHelper = ImagePickerHelper(vc: self, isTakePhoto: false, completion: { image in
            self.addSquareImage(image)
        })
    }
    
    private func addSquareImage(_ image: UIImage?) {
        let imgSize = image?.size ?? .zero
        
        if imgSize.width == imgSize.height {
            images.insert(image, at: 0)
            coverView.reloadData()
            return
        }
        
        let width = imgSize.width > imgSize.height ? imgSize.height : imgSize.width
        let newSize = CGSize(width: width, height: width)
        let squareImg = SquareImage.shared.squareImage(image, targetSize: newSize)
        
        images.insert(squareImg, at: 0)
        coverView.reloadData()
    }
}

//MARK: - RateCoverImageCVCellDelegate

extension RateProductVC: RateCoverImageCVCellDelegate {
    
    func deleteDidTap(cell: RateCoverImageCVCell) {
        if let indexPath = coverCV.indexPath(for: cell) {
            images.remove(at: indexPath.item)
            
            coverCV.performBatchUpdates {
                coverCV.deleteItems(at: [indexPath])
                
            } completion: { _ in
                self.coverView.reloadData()
            }
        }
    }
}
