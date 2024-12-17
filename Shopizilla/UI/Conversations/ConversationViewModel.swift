//
//  ConversationViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 30/05/2022.
//

import UIKit

class ConversationViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: ConversationVC
    
    lazy var userChats: [UserChat] = []
    
    //MARK: - Initializes
    init(vc: ConversationVC) {
        self.vc = vc
    }
}

//MARK: - GetData

extension ConversationViewModel {
    
    func getData() {
        User.fetchAllUser { users in
            appDL.allUsers = users
            
            Chat.fetchConversations { messages in
                let dict = Dictionary(grouping: messages) { element in
                    return element.fromUID == WebService.shared.getAPIKey().adminID ? element.toUID : element.fromUID
                }
                
                var userChats: [UserChat] = []
                
                for (key, value) in dict {
                    if let user = appDL.allUsers.first(where: { $0.uid == key }),
                       let last = value.last
                    {
                        var model = UserChatModel(user: user,
                                                  chats: value,
                                                  lastMessage: last,
                                                  product: nil,
                                                  prSize: last.prSize,
                                                  prColor: last.prColor)
                        
                        if let product = appDL.allProducts.first(where: {
                            $0.productID == last.prID &&
                            $0.category.uppercased() == last.prCategory.uppercased() &&
                            $0.subcategory.uppercased() == last.prSubcategory.uppercased()
                        }) {
                            model.product = product
                        }
                        
                        userChats.append(UserChat(model: model))
                    }
                }
                
                self.userChats = userChats.sorted(by: {
                    $0.lastMessage.createdTime > $1.lastMessage.createdTime
                })
                
                self.vc.hud?.removeHUD {}
                self.vc.reloadData()
            }
        }
    }
}

//MARK: - SetupCell

extension ConversationViewModel {
    
    func conversationTVCell(_ cell: ConversationTVCell, indexPath: IndexPath) {
        let gr = userChats[indexPath.row]
        let lastMes = gr.lastMessage
        
        cell.avatarImageView.image = nil
        cell.avatarImageView.backgroundColor = .lightGray
        cell.nameLbl.text = gr.user.fullName
        
        let isRead = lastMes.read == "0" && lastMes.fromUID != appDL.currentUser?.uid
        let isText = lastMes.type == ChatType.text.rawValue
        
        cell.mesLbl.font = UIFont(name: isRead ? FontName.ppSemiBold : FontName.ppRegular, size: 14.0)
        cell.mesLbl.textColor = isRead ? .darkGray : .gray
        cell.mesLbl.text = isText ? lastMes.text : "(\(lastMes.type.capitalized))"
        cell.tag = indexPath.row
        
        if let link = gr.user.avatarLink {
            DownloadImage.shared.downloadImage(link: link) { image in
                if cell.tag == indexPath.row {
                    cell.avatarImageView.image = image
                }
            }
        }
        
        if let date = longFormatter().date(from: lastMes.createdTime) {
            let range = Date().addingTimeInterval(-(60*60*24*7))...Date()
            
            let f = createDateFormatter()
            f.dateFormat = range.contains(date) ? "EEEE" : "MM/dd/yyyy"
            
            cell.timeLbl.text = f.string(from: date)
        }
    }
}
