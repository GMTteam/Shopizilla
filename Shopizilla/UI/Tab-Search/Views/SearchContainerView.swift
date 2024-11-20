//
//  SearchContainerView.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 26/04/2022.
//

import UIKit

class SearchContainerView: UIView {
    
    //MARK: - Properties
    let searchesView = SearchRecentlySearchesView()
    let viewedView = SearchRecentlyViewedView()
    let categoriesView = SearchCategoriesView()
    
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

extension SearchContainerView {
    
    private func setupViews() {
        isHidden = true
        clipsToBounds = true
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - UIStackView
        let stackView = createStackView(spacing: 10.0, distribution: .fill, axis: .vertical, alignment: .center)
        stackView.addArrangedSubview(searchesView)
        stackView.addArrangedSubview(viewedView)
        stackView.addArrangedSubview(categoriesView)
        addSubview(stackView)
        
        //TODO: - NSLayoutConstraint
        stackView.setupConstraint(superView: self, bottomC: -30.0)
    }
    
    func updateHeight(_ vc: UIViewController) {
        isHidden = false
        vc.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.33) {
            vc.view.layoutIfNeeded()
        }
    }
}
