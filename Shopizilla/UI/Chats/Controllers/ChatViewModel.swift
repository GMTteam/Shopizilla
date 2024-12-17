//
//  ChatViewModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 26/05/2022.
//

import UIKit

class ChatViewModel: NSObject {
    
    //MARK: - Properties
    private let vc: ChatVC
    
    lazy var groupChats: [GroupChat] = []
    
    //MARK: - Initializes
    init(vc: ChatVC) {
        self.vc = vc
    }
}

//MARK: - Get User

extension ChatViewModel {
    
    func getUser() {
        vc.fromUser = appDL.currentUser
        
        //Nếu Admin đăng nhập
        if User.isAdmin() {
            if let toUser = vc.toUser {
                self.updateToUser(toUser)
            }
            
        } else {
            //Nếu User đăng nhập
            User.fetchUser(userUID: WebService.shared.getAPIKey().adminID) { user in
                self.vc.toUser = user
                
                if let toUser = self.vc.toUser {
                    self.updateToUser(toUser)
                }
            }
        }
    }
    
    private func updateToUser(_ toUser: User) {
        vc.profileImageView.backgroundColor = .lightGray
        vc.fullNameLbl.text = toUser.fullName
        
        if let link = toUser.avatarLink, link != "" {
            DownloadImage.shared.downloadImage(link: link) { image in
                self.vc.profileImageView.image = image
            }
        }
        
        Connect.fetchConnected(userUID: toUser.uid) { connect in
            if let connect = connect {
                self.vc.toUser.model.connect = connect
                
                if let date = longFormatter().date(from: connect.lastTime) {
                    let time: Double = 60*60*24
                    let range = Date().addingTimeInterval(-time*7)...Date()
                    
                    let f = createDateFormatter()
                    //f.doesRelativeDateFormatting = true
                    
                    if range.contains(date) {
                        f.dateFormat = "EEEE, HH:mm a"
                        
                    } else {
                        f.dateFormat = "yyyy/MM/dd, HH:mm a"
                    }
                    
                    f.amSymbol = "AM"
                    f.pmSymbol = "PM"
                    
                    self.vc.typeLbl.text = "Online".localized() + ":" + " \(f.string(from: date))"
                }
            }
        }
        
        getChats(toUser.uid)
    }
}

//MARK: - Get Chat

extension ChatViewModel {
    
    func getChats(_ toUID: String) {
        Chat.fetchChats(toUID: toUID) { messages in
            //Lấy các giá trị theo ngày tạo và thông tin tin nhắn
            var newArray: [GroupChat] = []
            messages.forEach({
                let gr = GroupChat(createdDate: "\($0.createdTime.prefix(8))", chats: [$0])
                newArray.append(gr)
            })

            //Nhóm chúng lại theo ngày tạo
            let dict = Dictionary(grouping: newArray) { element in
                return element.createdDate
            }

            //Lưu trong GroupMess mới
            var newGroupMes: [GroupChat] = []
            for (key, value) in dict {
                var arr: [Chat] = []

                for v in value {
                    arr += v.chats
                }

                let mes = GroupChat(createdDate: key, chats: arr)
                newGroupMes.append(mes)
            }
            
            self.groupChats = newGroupMes.sorted(by: { $0.createdDate < $1.createdDate })
            
            //Khi truy cập từ tab Profile
            if self.vc.product == nil {
                var pr: Product?
                var lastMes: Chat?
                
                for gr in self.groupChats {
                    if let last = gr.chats.last {
                        pr = appDL.allProducts.first(where: {
                            $0.productID == last.prID &&
                            $0.category.uppercased() == last.prCategory.uppercased() &&
                            $0.subcategory.uppercased() == last.prSubcategory.uppercased()
                        })
                        
                        lastMes = last
                    }
                }
                
                self.vc.product = pr
                
                if let lastMes = lastMes {
                    self.vc.prSize = lastMes.prSize
                    self.vc.prColor = lastMes.prColor
                }
            }
            
            if !self.vc.isUpdate {
                self.vc.reloadData()
                
            } else {
                let count = self.groupChats.count
                
                if count != 0 {
                    DispatchQueue.main.async {
                        self.vc.chatCV.reloadData()
                        
                        let i = count-1
                        let gr = self.groupChats[i]
                        
                        let indexPath = IndexPath(item: gr.chats.count-1, section: i)
                        self.vc.chatCV.reloadItems(at: [indexPath])
                    }
                }
            }
            
            if self.vc.notifUID == "" {
                self.vc.scrollToBottom(false)
                
            } else {
                var section = 0
                var item = 0
                
                for i in 0..<self.groupChats.count {
                    for j in 0..<self.groupChats[i].chats.count {
                        if self.groupChats[i].chats[j].uid == self.vc.notifUID {
                            section = i
                            item = j
                            break
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(item: item, section: section)
                    self.vc.chatCV.scrollToItem(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
    }
}

//MARK: - SetupCell

extension ChatViewModel {
    
    func rateCoverImageCVCell(_ cell: RateCoverImageCVCell, indexPath: IndexPath) {
        cell.coverImageView.image = vc.images[indexPath.item]
        cell.delegate = vc
        
        cell.setupCornerRadius(8.0)
    }
    
    func chatLeftCVCell(_ cell: ChatLeftCVCell, indexPath: IndexPath) {
        let gr = groupChats[indexPath.section]
        let mes = gr.chats[indexPath.item]
        
        cell.timeLbl.text = dateF(mes.createdTime)
        cell.messageLbl.isHidden = mes.type != ChatType.text.rawValue
        cell.coverImageView.isHidden = mes.type == ChatType.text.rawValue
        cell.tag = indexPath.item
        
        let cvWidth: CGFloat
        let cvHeight: CGFloat
        
        if mes.type == ChatType.text.rawValue {
            cell.messageLbl.text = mes.text
            
            var mesW = mes.text.estimatedTextRect(fontN: FontName.ppRegular, fontS: 16).width + 35
            mesW = mesW <= ChatLeftCVCell.minWidth ? ChatLeftCVCell.minWidth : mesW
            mesW = mesW >= ChatLeftCVCell.maxWidth ? ChatLeftCVCell.maxWidth : mesW
            
            cvWidth = mesW
            cvHeight = getTextHeight(indexPath)
            
        } else {
            if mes.imageLink != "" {
                DownloadImage.shared.downloadImage(link: mes.imageLink) { image in
                    if cell.tag == indexPath.item {
                        cell.coverImageView.image = image
                    }
                }
            }
            
            cvWidth = getCoverSize(indexPath).width
            cvHeight = getCoverSize(indexPath).height
        }
        
        cell.widthConstraint.constant = cvWidth
        cell.heightConstraint.constant = cvHeight
    }
    
    func chatRightCVCell(_ cell: ChatRightCVCell, indexPath: IndexPath) {
        let mes = groupChats[indexPath.section].chats[indexPath.item]
        
        cell.timeLbl.text = dateF(mes.createdTime)
        
        cell.messageLbl.isHidden = mes.type != ChatType.text.rawValue
        cell.coverImageView.isHidden = mes.type == ChatType.text.rawValue
        cell.tag = indexPath.item
        
        let cvWidth: CGFloat
        let cvHeight: CGFloat
        
        if mes.type == ChatType.text.rawValue {
            cell.messageLbl.text = mes.text
            
            var mesW = mes.text.estimatedTextRect(fontN: FontName.ppRegular, fontS: 16).width + 35
            mesW = mesW <= ChatLeftCVCell.minWidth ? ChatLeftCVCell.minWidth : mesW
            mesW = mesW >= ChatLeftCVCell.maxWidth ? ChatLeftCVCell.maxWidth : mesW
            
            cvWidth = mesW
            cvHeight = getTextHeight(indexPath)
            
        } else {
            if mes.imageLink != "" {
                DownloadImage.shared.downloadImage(link: mes.imageLink) { image in
                    if cell.tag == indexPath.item {
                        cell.coverImageView.image = image
                    }
                }
            }
            
            cvWidth = getCoverSize(indexPath).width
            cvHeight = getCoverSize(indexPath).height
        }
        
        cell.widthConstraint.constant = cvWidth
        cell.heightConstraint.constant = cvHeight
    }
    
    func getTextHeight(_ indexPath: IndexPath) -> CGFloat {
        let mes = groupChats[indexPath.section].chats[indexPath.item]
        
        let mesR = mes.text.estimatedTextRect(width: ChatLeftCVCell.maxWidth-30, fontN: FontName.ppRegular, fontS: 16)
        let timeR = dateF(mes.createdTime).estimatedTextRect(fontN: FontName.ppRegular, fontS: 13)
        
        var mesH = mesR.height + timeR.height + 9
        mesH = mesH <= ChatLeftCVCell.minHeight ? ChatLeftCVCell.minHeight : mesH
        mesH = mesH >= ChatLeftCVCell.maxHeight ? ChatLeftCVCell.maxHeight : mesH
        
        return mesH
    }
    
    func getCoverSize(_ indexPath: IndexPath) -> CGSize {
        let mes = groupChats[indexPath.section].chats[indexPath.item]
        
        let coverW: CGFloat
        let coverH: CGFloat
        
        if mes.imageWidth == mes.imageHeight {
            coverW = ChatLeftCVCell.maxWidth
            coverH = ChatLeftCVCell.maxWidth
            
        } else if mes.imageWidth > mes.imageHeight {
            coverW = ChatLeftCVCell.maxWidth
            coverH = coverW * (mes.imageHeight/mes.imageWidth)
            
        } else {
            coverH = ChatLeftCVCell.maxHeight
            coverW = coverH * (mes.imageWidth/mes.imageHeight)
        }
        
        return CGSize(width: coverW, height: coverH)
    }
    
    private func dateF(_ str: String) -> String {
        if let date = longFormatter().date(from: str) {
            let f = createDateFormatter()
            f.dateFormat = "HH:mm a"
            f.amSymbol = "am"
            f.pmSymbol = "pm"
            
            return f.string(from: date)
        }
        
        return ""
    }
}
