//
//  ConversationVC.swift
//  Shopizilla
//
//  Created by Anh Tu on 30/05/2022.
//

import UIKit

class ConversationVC: UIViewController {
    
    //MARK: - Properties
    let separatorView = UIView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var hud: HUD?
    
    private var viewModel: ConversationViewModel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        viewModel.getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        if hud == nil && viewModel.userChats.count == 0 {
            hud = HUD.hud(view)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            Chat.removeConversationObserver()
        }
    }
}

//MARK: - Setups

extension ConversationVC {
    
    private func setupViews() {
        view.backgroundColor = .white
        navigationItem.title = "Chat"
        
        viewModel = ConversationViewModel(vc: self)
        
        //TODO: - SeparatorView
        setupSeparatorView(view: view, separatorView: separatorView)
        
        //TODO: - UITableView
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorColor = separatorColor
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        tableView.sectionFooterHeight = 0.0
        tableView.sectionHeaderHeight = 0.0
        tableView.rowHeight = 70.0
        tableView.register(ConversationTVCell.self, forCellReuseIdentifier: ConversationTVCell.id)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        //TODO: - NSLayoutConstraint
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - UITableViewDataSource

extension ConversationVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.userChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTVCell.id, for: indexPath) as! ConversationTVCell
        viewModel.conversationTVCell(cell, indexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension ConversationVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let gr = viewModel.userChats[indexPath.row]
        let vc = ChatVC()
        
        vc.toUser = gr.user
        vc.product = gr.product
        vc.prSize = gr.prSize
        vc.prColor = gr.prColor
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}

//let mes = gr.chats.remove(at: indexPath.item)
//
//if gr.chats.count <= 0 {
//    self.viewModel.groupChats.remove(at: indexPath.section)
//}
//
//self.chatCV.performBatchUpdates {
//    self.chatCV.deleteItems(at: [indexPath])
//
//    if gr.chats.count <= 0 {
//        self.chatCV.deleteSections(IndexSet(integer: indexPath.section))
//    }
//
//} completion: { _ in
//    mes.removeUserUIDs {
//        print("mes.userUIDs.count: \(mes.userUIDs.count)")
//    }
//}
