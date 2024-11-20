//
//  ShareVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/05/2022.
//

import UIKit
    
protocol ShareVCDelegate: AnyObject {
    func copyLinkDidTap(_ vc: ShareVC)
    func viaTextDidTap(_ vc: ShareVC, shortLink: String)
    func viaContactsDidTap(_ vc: ShareVC, shortLink: String)
    func moreDidTap(_ vc: ShareVC, shortLink: String)
}

class ShareVC: UIViewController {
    
    //MARK: - Properties
    private let containerView = UIView()
    private let popupView = UIView()
    private let headerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLbl = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let cancelBtn = ButtonAnimation()
    
    weak var delegate: ShareVCDelegate?
    
    private var shortLink = ""
    
    var product: Product!
    var imgLink = ""
    var titleTxt = ""
    
    lazy var models: [ShareModel] = {
        return ShareModel.shared()
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DownloadImage.shared.downloadImage(link: imgLink) { image in
            let targetSize = CGSize(width: 60.0, height: 60.0)
            let newImage = SquareImage.shared.squareImage(image, targetSize: targetSize)
            self.iconImageView.image = newImage
        }
        
        titleLbl.text = titleTxt
        createShortLink()
    }
}

//MARK: - Setups

extension ShareVC {
    
    private func setupViews() {
        view.backgroundColor = .clear
        
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        containerView.backgroundColor = .black.withAlphaComponent(0.0)
        view.addSubview(containerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(tap)
        
        //TODO: - PopupView
        let rowH: CGFloat = 60.0
        let headerH: CGFloat = 90.0
        
        let popW: CGFloat = screenWidth-40
        let popH: CGFloat = headerH + rowH*CGFloat(models.count) + 20 + 50
        let popX: CGFloat = (screenWidth - popW)/2
        let popY: CGFloat = screenHeight - popH - 30
        
        popupView.frame = CGRect(x: popX, y: popY, width: popW, height: popH)
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 16.0
        popupView.backgroundColor = .clear
        popupView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
        view.addSubview(popupView)
        
        //TODO: - TableView
        tableView.frame = CGRect(x: 0.0, y: 0.0, width: popW, height: popH-50-20)
        tableView.backgroundColor = .white
        tableView.clipsToBounds = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 16.0
        tableView.rowHeight = rowH
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.register(ShareTVCell.self, forCellReuseIdentifier: ShareTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        popupView.addSubview(tableView)
        
        //TODO: - HeaderView
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: popW, height: headerH)
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView
        
        //TODO: - IconImageView
        iconImageView.clipsToBounds = true
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layer.cornerRadius = 16.0
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.widthAnchor.constraint(equalToConstant: rowH).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: rowH).isActive = true
        
        setupShadow(iconImageView, radius: 1.0, opacity: 0.1)
        
        //TODO: - TitleLbl
        titleLbl.font = UIFont(name: FontName.ppBold, size: 16.0)
        titleLbl.textColor = .black
        titleLbl.numberOfLines = 3
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleLbl.widthAnchor.constraint(equalToConstant: popW-15*2-rowH-10).isActive = true
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .horizontal, alignment: .center)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLbl)
        headerView.addSubview(stackView)
        
        stackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15.0).isActive = true
        
        //TODO: - CancelBtn
        let cancelAtt: [NSAttributedString.Key: Any] = [
            .font: btnFont,
            .foregroundColor: defaultColor
        ]
        let cancelAttr = NSMutableAttributedString(string: "Cancel".localized(), attributes: cancelAtt)
        
        cancelBtn.frame = CGRect(x: 0.0, y: popH-50, width: popW, height: 50.0)
        cancelBtn.setAttributedTitle(cancelAttr, for: .normal)
        cancelBtn.backgroundColor = .white
        cancelBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 16.0
        cancelBtn.delegate = self
        popupView.addSubview(cancelBtn)
        
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = .black.withAlphaComponent(0.7)
            self.popupView.transform = .identity
        }
    }
    
    @objc private func removeDidTap() {
        removeHandler {}
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.popupView.transform = CGAffineTransform(translationX: 0.0, y: screenHeight)
            
        } completion: { (_) in
            self.view.removeFromSuperview()
            self.removeFromParent()
            
            completion()
        }
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    private func createShortLink() {
        guard let product = product else { return }
        let link = DynamicLinkModel.shared().link + "product?uid=\(product.uid)"
        let imageURL = URL(string: product.imageURL)
        
        DynamicLinkModel.shared().shortLinks(link, title: product.name, imgURL: imageURL) { url in
            if let url = url {
                self.shortLink = url.absoluteString
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension ShareVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShareTVCell.id, for: indexPath) as! ShareTVCell
        let model = models[indexPath.row]
        
        cell.selectionStyle = .none
        cell.iconImgView.image = model.image?.withRenderingMode(.alwaysTemplate)
        cell.iconImgView.tintColor = defaultColor
        cell.titleLbl.text = model.title
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ShareVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard shortLink != "" else {
            createShortLink()
            return
        }
        
        let model = models[indexPath.row]
        
        switch model.index {
        case 0: //Copy Link
            UIPasteboard.general.string = shortLink
            delegate?.copyLinkDidTap(self)
            
        case 1: //Via Text
            delegate?.viaTextDidTap(self, shortLink: shortLink)
            
        case 2: //More
            delegate?.moreDidTap(self, shortLink: shortLink)
            
        case 3: //Via Contacts
            print("Via Contacts")
            delegate?.viaContactsDidTap(self, shortLink: shortLink)
            
        default: break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .zero
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.rowHeight
    }
}

//MARK: - ButtonAnimationDelegate

extension ShareVC: ButtonAnimationDelegate {
    
    func btnAnimationDidTap(_ sender: ButtonAnimation) {
        removeHandler {}
    }
}
