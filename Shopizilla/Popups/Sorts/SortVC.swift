//
//  SortVC.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 18/04/2022.
//

import UIKit

protocol SortVCDelegate: AnyObject {
    func selectedFilter(_ vc: SortVC, selected: SortModel)
}

class SortVC: UIViewController {
    
    //MARK: - Properties
    weak var delegate: SortVCDelegate?
    
    private let containerView = UIView()
    private let threeDotsView = UIView()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    lazy var models: [SortModel] = {
        return SortModel.shared()
    }()
    var selected: SortModel?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
}

//MARK: - Setups

extension SortVC {
    
    func setupViews(_ dotsY: CGFloat) {
        //TODO: - ContainerView
        containerView.frame = view.bounds
        containerView.clipsToBounds = true
        containerView.backgroundColor = .clear
        containerView.isUserInteractionEnabled = true
        view.addSubview(containerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(removeDidTap))
        containerView.addGestureRecognizer(tap)
        
        //TODO: - ThreeDotsView
        let dotsW: CGFloat = screenWidth/2
        let dotsH: CGFloat = CGFloat(models.count)*50
        let dotsX: CGFloat = screenWidth - dotsW - 20 - 40*2
        let dotsRect = CGRect(x: dotsX, y: dotsY, width: dotsW, height: dotsH)

        threeDotsView.clipsToBounds = true
        threeDotsView.layer.cornerRadius = 20.0
        threeDotsView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        threeDotsView.frame = dotsRect
        view.insertSubview(threeDotsView, aboveSubview: containerView)
        
        threeDotsView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        
        UIView.animate(withDuration: 0.33) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.threeDotsView.transform = .identity
        }
        
        setupTableView()
        
        threeDotsView.backgroundColor = .white
        tableView.backgroundColor = .white
    }
    
    @objc private func removeDidTap(_ sender: UIGestureRecognizer) {
        removeHandler {}
    }
    
    private func setupTableView() {
        tableView.clipsToBounds = true
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.layer.cornerRadius = 20.0
        tableView.rowHeight = 50.0
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        tableView.isScrollEnabled = false
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
        tableView.register(SortTVCell.self, forCellReuseIdentifier: SortTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        threeDotsView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: threeDotsView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: threeDotsView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: threeDotsView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: threeDotsView.bottomAnchor),
        ])
    }
    
    func removeHandler(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.25) {
            self.containerView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self.threeDotsView.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
            self.threeDotsView.alpha = 0.0
            
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
}

//MARK: - UITableViewDataSource

extension SortVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SortTVCell.id, for: indexPath) as! SortTVCell
        let model = models[indexPath.row]
        
        cell.titleLbl.text = model.title
        cell.selectionStyle = .none
        cell.accessoryType = selected?.title == model.title ? .checkmark : .none
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension SortVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selected = models[indexPath.row]
        
        if let selected = selected {
            delegate?.selectedFilter(self, selected: selected)
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
