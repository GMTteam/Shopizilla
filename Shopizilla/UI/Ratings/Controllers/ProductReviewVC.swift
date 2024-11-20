//
//  ProductReviewVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 17/05/2022.
//

import UIKit

class ProductReviewVC: UIViewController {
    
    //MARK: - Properties
    private let separatorView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let headerView = ProductReviewHeaderView()
    
    lazy var reviews: [Review] = []
    lazy var users: [User] = []
    
    var kTitle = ""
    var rating1 = 0
    var rating2 = 0
    var rating3 = 0
    var rating4 = 0
    var rating5 = 0
    var total = 0
    var avg: Double = 0.0
    var ratingImg: UIImage?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        headerView.updateUI(avg: avg, ratingImg: ratingImg, review: total, rating1: rating1, rating2: rating2, rating3: rating3, rating4: rating4, rating5: rating5)
        
        if users.count == 0 {
            getUsers()
        }
    }
}

//MARK: - Setups

extension ProductReviewVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = kTitle
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 70.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.register(ProductReviewTVCell.self, forCellReuseIdentifier: ProductReviewTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        let sp: CGFloat = 20*2 + 20 + 5*5
        let headerH: CGFloat = 40 + 20 + 20*5 + sp
        headerView.frame = CGRect(x: 0.0, y: 0.0, width: screenWidth, height: headerH)
        tableView.tableHeaderView = headerView
        
        headerView.setupViews()
        
        tableView.setupConstraint(superView: view, subview: separatorView)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - GetData

extension ProductReviewVC {
    
    private func getUsers() {
        if appDL.allUsers.count == 0 {
            User.fetchAllUser { users in
                appDL.allUsers = users
                self.users = users
                self.reloadData()
            }
            
        } else {
            users = appDL.allUsers
            reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension ProductReviewVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductReviewTVCell.id, for: indexPath) as! ProductReviewTVCell
        let review = reviews[indexPath.row]
        
        cell.avatarImageView.image = nil
        cell.avatarImageView.backgroundColor = .lightGray
        cell.tag = indexPath.row
        
        if let user = users.first(where: { $0.uid == review.userID }) {
            if let link = user.avatarLink {
                DownloadImage.shared.downloadImage(link: link) { image in
                    if cell.tag == indexPath.row {
                        let targetSize = CGSize(width: 60, height: 60)
                        let squareImage = SquareImage.shared.squareImage(image, targetSize: targetSize)
                        cell.avatarImageView.image = squareImage
                    }
                }
            }
            
            cell.nameLbl.text = user.fullName
        }
        
        if let date = longFormatter().date(from: review.createdTime) {
            let f = createDateFormatter()
            f.dateFormat = "MMM d, yyyy"
            cell.timeLbl.text = f.string(from: date)
        }
        
        cell.starImageView.image = UIImage(named: "icon-rating\(review.rating)")
        
        cell.desLbl.text = review.description
        cell.desLbl.isHidden = review.description == ""
        cell.coverView.isHidden = review.imageURLs.count == 0
        
        if review.imageURLs.count >= 2 {
            cell.coverView.coverImageView_1.isHidden = false
            cell.coverView.coverImageView_2.isHidden = false
            cell.coverView.moreBtn.isHidden = review.imageURLs.count == 2
            
            let targetSize = CGSize(width: 50, height: 50)
            
            DownloadImage.shared.downloadImage(link: review.imageURLs[0]) { image in
                if cell.tag == indexPath.row {
                    let squareImage = SquareImage.shared.squareImage(image, targetSize: targetSize)
                    cell.coverView.coverImageView_1.image = squareImage
                }
            }
            DownloadImage.shared.downloadImage(link: review.imageURLs[1]) { image in
                if cell.tag == indexPath.row {
                    let squareImage = SquareImage.shared.squareImage(image, targetSize: targetSize)
                    cell.coverView.coverImageView_2.image = squareImage
                }
            }
            
        } else if review.imageURLs.count == 1 {
            cell.coverView.coverImageView_1.isHidden = false
            cell.coverView.coverImageView_2.isHidden = true
            cell.coverView.moreBtn.isHidden = true
            
            DownloadImage.shared.downloadImage(link: review.imageURLs[0]) { image in
                if cell.tag == indexPath.row {
                    let targetSize = CGSize(width: 50, height: 50)
                    let squareImage = SquareImage.shared.squareImage(image, targetSize: targetSize)
                    cell.coverView.coverImageView_1.image = squareImage
                }
            }
        }
        
        cell.delegate = self
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ProductReviewVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let review = reviews[indexPath.row]
        
        let sp: CGFloat = 20*2
        let avatarH: CGFloat = 50.0
        var desH = review.description.estimatedTextRect(width: screenWidth-40, fontN: FontName.ppRegular, fontS: 13).height + 10
        var coverH: CGFloat = 10 + 50
        
        if review.description == "" {
            desH = 0.0
        }
        
        if review.imageURLs.count == 0 {
            coverH = 0.0
        }
        
        return sp + avatarH + desH + coverH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 5.0))
        headerView.backgroundColor = UIColor(hex: 0xF6F6F6)
        return headerView
    }
}

//MARK: - ProductReviewTVCellDelegate

extension ProductReviewVC: ProductReviewTVCellDelegate {
    
    func coverDidTap(_ cell: ProductReviewTVCell, coverIndex: Int) {
        if let indexPath = tableView.indexPath(for: cell) {
            let index: Int
            if coverIndex == 0 {
                index = 0
                
            } else {
                index = 1
            }
            
            goToViewImageVC(indexPath: indexPath, index: index)
        }
    }
    
    func loadMoreDidTap(_ cell: ProductReviewTVCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            goToViewImageVC(indexPath: indexPath, index: 0)
        }
    }
    
    private func goToViewImageVC(indexPath: IndexPath, index: Int) {
        let review = reviews[indexPath.row]
        let vc = ViewImageVC()
        
        vc.index = index
        vc.imageLinks = review.imageURLs
        vc.modalPresentationStyle = .fullScreen
        
        present(vc, animated: true)
    }
}
