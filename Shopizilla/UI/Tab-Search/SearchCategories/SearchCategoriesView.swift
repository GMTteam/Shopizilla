//
//  SearchCategoriesView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchCategoriesView: UIView {
    
    //MARK: - Properties
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let rowHeight: CGFloat = 50.0
    var tvHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Initializes
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: - Setups

extension SearchCategoriesView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        
        tvHeightConstraint = heightAnchor.constraint(equalToConstant: rowHeight)
        tvHeightConstraint.isActive = true
        
        //TODO: - TableView
        tableView.backgroundColor = .white
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.isScrollEnabled = false
        tableView.rowHeight = rowHeight
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.separatorColor = separatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        tableView.register(SearchCategoriesTVCell.self, forCellReuseIdentifier: SearchCategoriesTVCell.id)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tableView)
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupDataSourceAndDelegate(dl: UITableViewDataSource & UITableViewDelegate) {
        tableView.dataSource = dl
        tableView.delegate = dl
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func updateHeight(_ vc: UIViewController, subcats: [String]) {
        isHidden = subcats.count == 0
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            self.tvHeightConstraint.constant = CGFloat(subcats.count) * self.rowHeight
            vc.view.layoutIfNeeded()
        }
    }
}
