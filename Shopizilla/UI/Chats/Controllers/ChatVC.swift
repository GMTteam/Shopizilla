//
//  ChatVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 26/05/2022.
//

import UIKit

class ChatVC: UIViewController {
    
    //MARK: - Properties
    let coverView = ChatCoverView()
    let sentView = ChatSentView()
    
    var coverCV: UICollectionView { return coverView.collectionView }
    
    let separatorView = UIView()
    let chatCV = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let profileImageView = UIImageView()
    let fullNameLbl = UILabel()
    let typeLbl = UILabel()
    
    let notifView = NotifView()
    
    //Khi click thông báo đẩy, sẽ cuộn đến Item chứa UID này
    var notifUID = ""
    
    var prSize = "" //Kích thước sản phẩm
    var prColor = "" //Màu sản phẩm
    var product: Product! //Sản phẩm đang chọn để Chat
    
    var chatTxt = "" //Lưu văn bản
    var images: [UIImage?] = [] //Lưu hình ảnh
    
    var toUser: User!
    var fromUser: User!
    var isUpdate = false //Khi gửi tin nhắn. Reload item cuối
    
    //Giới hạn ký tự Chat
    private let limit = 160
    
    //Dùng để tính chiều cao tối đa khi nhập Chat
    private var txtHeight: CGFloat {
        return "MjgW".estimatedTextRect(fontN: FontName.ppRegular, fontS: 16.0).height + 5
    }
    
    //Ràng buộc cạnh dưới cùng của phần Chat
    private var sentBottomConstraint: NSLayoutConstraint!
    
    //Cạnh dưới của phần Chat
    private var chatCVBottomConstraint: NSLayoutConstraint!
    
    private var photoAlertVC: PhotoAlertVC?
    private var imagePickerHelper: ImagePickerHelper?
    
    private var willShowObs: Any?
    private var willHideObs: Any?
    
    private var viewModel: ChatViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObserver()
        
        viewModel.getUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupNavi()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverBy(observer: willShowObs)
        removeObserverBy(observer: willHideObs)
        
        User.otherListener?.remove()
        User.otherListener = nil
        
        Connect.removeObserver()
        Chat.removeObserver()
    }
}

//MARK: - Setups

extension ChatVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        
        viewModel = ChatViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - ChatCV
        chatCV.setupCollectionView()
        chatCV.keyboardDismissMode = .interactive
        chatCV.register(ChatLeftCVCell.self, forCellWithReuseIdentifier: ChatLeftCVCell.id)
        chatCV.register(ChatRightCVCell.self, forCellWithReuseIdentifier: ChatRightCVCell.id)
        chatCV.register(ChatHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ChatHeaderView.id)
        chatCV.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCell")
        chatCV.dataSource = self
        chatCV.delegate = self
        view.addSubview(chatCV)
        
        chatCV.setupLayout(scrollDirection: .vertical, lineSpacing: 2.0, itemSpacing: 2.0)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(coverView)
        stackView.addArrangedSubview(sentView)
        view.insertSubview(stackView, aboveSubview: chatCV)
        
        //TODO: - SentView
        sentView.attachBtn.delegate = self
        sentView.attachBtn.tag = 0
        
        sentView.sentBtn.delegate = self
        sentView.sentBtn.tag = 1
        
        sentView.textView.delegate = self
        
        //TODO: - CoverView
        coverView.isHidden = true
        coverView.setupDataSourceAndDelegate(dl: self)
        
        //TODO: - NSLayoutConstraint
        chatCVBottomConstraint = chatCV.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(sentView.btHeight+5))
        chatCVBottomConstraint.isActive = true
        
        sentBottomConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        sentBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            chatCV.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            chatCV.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            chatCV.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        //TODO: - NotifView
        notifView.setupViews(view)
    }
    
    func scrollToBottom(_ anim: Bool) {
        let count = viewModel.groupChats.count
        
        if count != 0 {
            DispatchQueue.main.async {
                let i = count-1
                let gr = self.viewModel.groupChats[i]
                
                let indexPath = IndexPath(item: gr.chats.count-1, section: i)
                self.chatCV.scrollToItem(at: indexPath, at: .bottom, animated: anim)
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.chatCV.reloadData()
        }
    }
}

//MARK: - Navi

extension ChatVC {
    
    private func setupNavi() {
        //TODO: - TitleView
        let titleView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth-(40*3), height: 40.0))
        titleView.clipsToBounds = true
        titleView.backgroundColor = .white
        
        //TODO: - NavigationItem
        navigationItem.titleView = titleView
        
        //TODO: - ProfileImageView
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20.0
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
        //TODO: - FullNameLbl
        fullNameLbl.font = UIFont(name: FontName.ppMedium, size: 14.0)
        fullNameLbl.textColor = .black
        
        //TODO: - TypeLbl
        typeLbl.font = UIFont(name: FontName.ppMedium, size: 12.0)
        typeLbl.textColor = .gray
        
        //TODO: - UIStackView
        let nameSV = createStackView(spacing: 0.0, distribution: .fill, axis: .vertical, alignment: .leading)
        nameSV.addArrangedSubview(fullNameLbl)
        nameSV.addArrangedSubview(typeLbl)
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 5.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(profileImageView)
        stackView.addArrangedSubview(nameSV)
        titleView.addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: titleView.leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: titleView.trailingAnchor)
        ])
    }
}

//MARK: - AddObserver

extension ChatVC {
    
    private func addObserver() {
        willShowObs = NotificationCenter.default.addObserver(forName: .keyboardWillShow, object: nil, queue: nil) { notif in
            if let height = (notif.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
               let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
            {
                let bt = height - bottomPadding
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.sentBottomConstraint.constant = -bt
                    self.chatCVBottomConstraint.constant = -(self.sentView.btHeight + 5 + bt)
                    self.view.layoutIfNeeded()
                }
            }
        }
        willHideObs = NotificationCenter.default.addObserver(forName: .keyboardWillHide, object: nil, queue: nil) { notif in
            if let dr = (notif.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue {
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: dr) {
                    self.sentBottomConstraint.constant = 0.0
                    self.chatCVBottomConstraint.constant = -(self.sentView.btHeight + 5)
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
}

//MARK: - ButtonAnimationDelegate

extension ChatVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        if sender.tag == 0 { //Attach
            guard images.count < 1 else {
                return
            }
            sentView.textView.resignFirstResponder()
            
            photoAlertVC?.removeFromParent()
            photoAlertVC?.view.removeFromSuperview()
            photoAlertVC = nil
            
            photoAlertVC = PhotoAlertVC()
            photoAlertVC!.view.frame = kWindow.bounds
            photoAlertVC!.delegate = self
            kWindow.addSubview(photoAlertVC!.view)
            
        } else if sender.tag == 1 { //Sent
            guard let fromUser = fromUser, let toUser = toUser else {
                return
            }
            
            isUpdate = true
            sentView.reset()
            sentView.resetHeightFor(self)
            
            let userUIDs = [fromUser.uid, toUser.uid].sorted(by: { $0 < $1 })
            let model = ChatModel(type: "",
                                  fromUID: fromUser.uid,
                                  toUID: toUser.uid,
                                  prSize: prSize,
                                  prColor: prColor,
                                  userUIDs: userUIDs)
            let mes = Chat(model: model)
            
            if let product = product {
                mes.model.prID = product.productID
                mes.model.prCategory = product.category
                mes.model.prSubcategory = product.subcategory
            }
            
            //Gửi hình ảnh
            if images.count != 0 {
                if let img = images.first, let image = img {
                    mes.model.type = ChatType.image.rawValue
                    mes.model.imageWidth = image.size.width
                    mes.model.imageHeight = image.size.height
                    
                    mes.saveChat {
                        //Lưu hình ảnh lên Storage và Cập nhật Firestore
                        let storage = FirebaseStorage(image: image)
                        
                        storage.saveChat(chatUID: mes.uid) { link in
                            mes.updateImageLink(imageLink: link ?? "") {
                                self.pushNotifTo(toUser,
                                                 body: "\(fromUser.fullName) " + "sent you a image".localized(),
                                                 imageLink: link ?? "",
                                                 notifUID: mes.uid)
                            }
                        }
                    }
                }
                
                images.removeAll()
                setupAlphaFor()
                coverView.reloadData()
                
                return
            }
            
            //Gửi văn bản
            if chatTxt != "" {
                mes.model.type = ChatType.text.rawValue
                mes.model.text = chatTxt
                
                mes.saveChat {
                    self.pushNotifTo(toUser, body: mes.text, imageLink: "", notifUID: mes.uid)
                }
                
                chatTxt = ""
            }
        }
    }
    
    private func pushNotifTo(_ toUser: User, body: String, imageLink: String, notifUID: String) {
        //Khi người dùng đang bận. Hãy đẩy thông báo cho họ
        if let connect = toUser.connects, connect.online != "2" {
            //Đẩy 1 thông báo khi đã gửi tin nhắn
            PushNotification.shared.sendPushNotifToChat(
                toUID: toUser.uid,
                title: "You have a new message".localized(),
                body: body,
                imageLink: imageLink,
                notifUID: notifUID,
                type: PushNotification.NotifKey.Messages.rawValue)
        }
    }
}

//MARK: - UITextViewDelegate

extension ChatVC: UITextViewDelegate {
    
    private func setupHeightForTextView(_ textView: UITextView) {
        textView.isScrollEnabled = false
        
        let txtH = txtHeight*4
        let height = CGFloat.greatestFiniteMagnitude
        let width = textView.frame.size.width
        
        let size = CGSize(width: width, height: height)
        textView.sizeThatFits(size)
        
        var newFrame = textView.frame
        sentView.newSize = textView.sizeThatFits(size)
        
        newFrame.size = CGSize(width: max(sentView.newSize.width, width), height: sentView.newSize.height)
        textView.frame = newFrame
        
        sentView.newSize.height = (sentView.newSize.height <= sentView.tvHeight) ? sentView.tvHeight : sentView.newSize.height
        sentView.newSize.height = (sentView.newSize.height >= txtH) ? txtH : sentView.newSize.height
        
        sentView.setupHeightFor(self, isAnim: false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text,
           !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            chatTxt = text
            
        } else {
            chatTxt = ""
        }
        
        textView.isScrollEnabled = true
        
        if chatTxt != "" {
            if sentView.tvHeightConstraint.constant < txtHeight*4 {
                if textView.contentSize.height > sentView.tvHeightConstraint.constant {
                    setupHeightForTextView(textView)
                    
                } else if textView.contentSize.height < sentView.tvHeightConstraint.constant {
                    setupHeightForTextView(textView)
                }
                
            } else {
                if textView.contentSize.height < sentView.tvHeightConstraint.constant {
                    setupHeightForTextView(textView)
                }
            }
            
            if sentView.tvHeightConstraint.constant == txtHeight*4 {
                textView.isScrollEnabled = true
            }
            
        } else {
            textView.text = nil
            sentView.resetHeightFor(self)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == sentView.placeholderTxt {
            textView.text = nil
            textView.textColor = .black
        }
        
        textView.becomeFirstResponder()
        scrollToBottom(true)
        
        if chatTxt != "" {
            //let pos = textView.endOfDocument
            //textView.selectedTextRange = textView.textRange(from: pos, to: pos)
            
            sentView.setupHeightFor(self, isAnim: true)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == nil || textView.text == "" {
            textView.text = sentView.placeholderTxt
            textView.textColor = .placeholderText
        }
        
        textView.resignFirstResponder()
        sentView.resetHeightFor(self)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let kText = textView.text, let range = Range(range, in: kText) else {
            sentView.countLbl.text = "0/160"
            return false
        }
        
        let count = kText.count - kText[range].count + text.count
        
        if text == "\n" && count == 1 {
            textView.resignFirstResponder()
            return false
        }
        
        var num = limit - count
        num = num <= 0 ? 0 : num
        
        sentView.countLbl.text = "\(num)/160"
        
        return count < limit
    }
}

//MARK: - UICollectionViewDataSource

extension ChatVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionView == coverCV ? 1 : viewModel.groupChats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coverCV {
            return images.count
            
        } else { //collectionView == chatCV
            return viewModel.groupChats[section].chats.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == coverCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RateCoverImageCVCell.id, for: indexPath) as! RateCoverImageCVCell
            viewModel.rateCoverImageCVCell(cell, indexPath: indexPath)
            return cell
            
        } else { //collectionView == chatCV
            let gr = viewModel.groupChats[indexPath.section]
            let mes = gr.chats[indexPath.item]
            
            if mes.fromUID == appDL.currentUser?.uid {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatRightCVCell.id, for: indexPath) as! ChatRightCVCell
                viewModel.chatRightCVCell(cell, indexPath: indexPath)
                return cell
                
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatLeftCVCell.id, for: indexPath) as! ChatLeftCVCell
                viewModel.chatLeftCVCell(cell, indexPath: indexPath)
                return cell
            }
        }
    }
}

//MARK: - UICollectionViewDelegate

extension ChatVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coverCV {
            print("CoverImage: \(indexPath.item)")
            
        } else { //collectionView == chatCV
            
        }
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ChatVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == coverCV {
            return CGSize(width: 60.0, height: 60.0)
            
        } else { //collectionView == chatCV
            let mes = viewModel.groupChats[indexPath.section].chats[indexPath.item]
            let height: CGFloat
            
            if mes.type == "text" {
                height = viewModel.getTextHeight(indexPath)
                
            } else {
                height = viewModel.getCoverSize(indexPath).height
            }
            
            return CGSize(width: screenWidth, height: height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == chatCV {
            if kind == UICollectionView.elementKindSectionHeader {
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ChatHeaderView.id, for: indexPath) as! ChatHeaderView
                let gr = viewModel.groupChats[indexPath.section]
                
                let f = createDateFormatter()
                f.dateFormat = "yyyyMMdd"
                
                if let date = f.date(from: gr.createdDate) {
                    let f = createDateFormatter()
                    f.dateFormat = "EEEE, MMM dd, yyyy"
                    
                    header.timeLbl.text = f.string(from: date)
                }
                
                return header
                
            } else if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterCell", for: indexPath)
                footer.backgroundColor = .blue
                return footer
            }
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == chatCV {
            return CGSize(width: screenWidth, height: 50.0)
        }
        
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if collectionView == chatCV {
            return CGSize(width: screenWidth, height: 0.0)
        }
        
        return .zero
    }
}

//MARK: - Preview

extension ChatVC {
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let id = NSString(string: "\(indexPath.section),\(indexPath.item)")
        
        return UIContextMenuConfiguration(identifier: id, previewProvider: { () -> UIViewController? in
            return nil
            
        }, actionProvider: { _ in
            return self.makeContextMenu(indexPath)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = getIndexPath(configuration: configuration) else {
            return nil
        }
        let mes = viewModel.groupChats[indexPath.section].chats[indexPath.item]

        if mes.fromUID == appDL.currentUser?.uid {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ChatRightCVCell else {
                return nil
            }
            
            return targetedPreview(cell.containerView)

        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ChatLeftCVCell else {
                return nil
            }

            return targetedPreview(cell.containerView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = getIndexPath(configuration: configuration) else {
            return nil
        }
        guard indexPath.section <= viewModel.groupChats.count-1 else {
            return nil
        }
        guard indexPath.item <= viewModel.groupChats[indexPath.section].chats.count-1 else {
            return nil
        }
        
        let mes = viewModel.groupChats[indexPath.section].chats[indexPath.item]

        if mes.fromUID == appDL.currentUser?.uid {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ChatRightCVCell else {
                return nil
            }

            return targetedPreview(cell.containerView)

        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ChatLeftCVCell else {
                return nil
            }

            return targetedPreview(cell.containerView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
    }
    
    private func getIndexPath(configuration: UIContextMenuConfiguration) -> IndexPath? {
        guard let id = configuration.identifier as? String else {
            return nil
        }
        let components = id.components(separatedBy: ",")
        
        guard let first = components.first,
              let last = components.last,
              let section = Int(first),
              let item = Int(last) else {
            return nil
        }
        let indexPath = IndexPath(item: item, section: section)
        
        return indexPath
    }
    
    private func targetedPreview(_ containerView: UIView) -> UITargetedPreview {
        let targeted = UITargetedPreview(view: containerView)
        targeted.parameters.backgroundColor = .clear
        
        return targeted
    }
    
    private func makeContextMenu(_ indexPath: IndexPath) -> UIMenu {
        let gr = viewModel.groupChats[indexPath.section]
        
        let delAct = UIAction(title: "Delete".localized(), image: UIImage(named: "preview-delete"), attributes: .destructive) { _ in
            let mes = gr.chats.remove(at: indexPath.item)
            
            if gr.chats.count <= 0 {
                self.viewModel.groupChats.remove(at: indexPath.section)
            }
            
            self.chatCV.performBatchUpdates {
                self.chatCV.deleteItems(at: [indexPath])
                
                if gr.chats.count <= 0 {
                    self.chatCV.deleteSections(IndexSet(integer: indexPath.section))
                }
                
            } completion: { _ in
                mes.removeUserUIDs {
                    print("mes.userUIDs.count: \(mes.userUIDs.count)")
                }
            }
        }
        
        let mes = gr.chats[indexPath.item]
        var elements: [UIMenuElement] = []
        
        //Nếu tin nhắn là văn bản
        if mes.type == ChatType.text.rawValue {
            let copyAct = UIAction(title: "Copy".localized(), image: UIImage(named: "preview-copy")) { _ in
                UIPasteboard.general.string = mes.text
                self.notifView.setupNotifView("Copied".localized())
            }
            elements = [copyAct, delAct]
            
        } else {
            //Nếu tin nhắn là hình ảnh
            let downAct = UIAction(title: "Download".localized(), image: UIImage(named: "preview-download")) { _ in
                DownloadImage.shared.downloadImage(link: mes.imageLink) { image in
                    if let image = image {
                        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage), nil)
                    }
                }
            }
            elements = [downAct, delAct]
        }
        
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: elements)
    }
    
    @objc private func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            notifView.setupNotifView("Download Error".localized())
            
        } else {
            notifView.setupNotifView("Downloaded".localized())
        }
    }
}

//MARK: - RateCoverImageCVCellDelegate

extension ChatVC: RateCoverImageCVCellDelegate {
    
    func deleteDidTap(cell: RateCoverImageCVCell) {
        if let indexPath = coverCV.indexPath(for: cell) {
            images.remove(at: indexPath.item)
            
            coverCV.performBatchUpdates {
                coverCV.deleteItems(at: [indexPath])
                
            } completion: { _ in
                self.view.layoutIfNeeded()
                
                UIView.animate(withDuration: 0.25) {
                    self.setupAlphaFor()
                    self.view.layoutIfNeeded()
                    
                } completion: { _ in }
                
                self.coverView.reloadData()
            }
        }
    }
}

//MARK: - PhotoAlertVCDelegate

extension ChatVC: PhotoAlertVCDelegate {
    
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
        images.append(image)
        
        setupAlphaFor()
        coverView.reloadData()
    }
    
    private func setupAlphaFor() {
        let isBool = images.count == 0
        
        coverView.isHidden = isBool
        
        sentView.attachBtn.alpha = isBool ? 1.0 : 0.5
        sentView.attachBtn.isUserInteractionEnabled = isBool
        
        sentView.textView.alpha = isBool ? 1.0 : 0.5
        sentView.textView.isUserInteractionEnabled = isBool
        
        let bt: CGFloat
        if isBool {
            bt = sentView.btHeight + 5
            
        } else {
            bt = sentView.btHeight + 80 + 5
        }
        
        chatCVBottomConstraint.constant = -bt
        
        sentView.setPlaceholderFor()
        chatTxt = ""
    }
}
