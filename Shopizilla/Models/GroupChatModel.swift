//
//  GroupChatModel.swift
//  Shopizilla
//
//  Created by Thanh Hoang on 28/05/2022.
//

import Foundation

class GroupChat {
    
    let createdDate: String
    var chats: [Chat]
    
    init(createdDate: String, chats: [Chat]) {
        self.createdDate = createdDate
        self.chats = chats
    }
}
