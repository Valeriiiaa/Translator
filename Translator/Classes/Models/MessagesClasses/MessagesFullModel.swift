//
//  MessagesModel.swift
//  Translator
//
//  Created by Valeriya Chernyak on 26.07.2023.
//

import Foundation

class MessagesFullModel: BaseMessagesModel  {
   
    let id: String
    let textFirst: String
    let textSecond: String
    let isMe: Bool
    
    init(id: String, textFirst: String, textSecond: String, isMe: Bool) {
        self.id = id
        self.textFirst = textFirst
        self.textSecond = textSecond
        self.isMe = isMe
    }
}
