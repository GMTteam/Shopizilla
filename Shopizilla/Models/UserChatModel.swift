//
//  UserChatModel.swift
//  Shopizilla
//
//  Created by Anh Tu on 30/05/2022.
//

import Foundation

struct UserChatModel {
    
    let user: User
    var chats: [Chat]
    var lastMessage: Chat //Tin nhắn cuối cùng
    var product: Product?
    var prSize: String
    var prColor: String
}

class UserChat {
    
    var model: UserChatModel
    
    var user: User { return model.user }
    var chats: [Chat] { return model.chats }
    var lastMessage: Chat { return model.lastMessage }
    var product: Product? { return model.product }
    var prSize: String { return model.prSize }
    var prColor: String { return model.prColor }
    
    init(model: UserChatModel) {
        self.model = model
    }
}
