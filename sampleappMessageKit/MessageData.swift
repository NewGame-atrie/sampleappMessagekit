//
//  MessageData.swift
//  sampleappMessageKit
//
//  Created by 北田菜穂 on 2020/12/03.
//
import Foundation
import MessageKit

// messageId - uuid（アプリ側で作るID）
// sender - senderId = 送信者のユーザーID, displayName = 送信者の名前
// date - 送信日時（アプリ側で作るID）
// kind - 送信テキスト

public struct Sender: SenderType {
    public let senderId: String
    public let displayName: String
}

public struct MessageData: MessageType {
    public var messageId: String
    public var sender: SenderType
    public var sentDate: Date
    public var kind: MessageKind
    
    public init(kind: MessageKind, sender: SenderType, messageId: String, date: Date) {
        self.kind = kind
        self.sender = sender
        self.messageId = messageId
        self.sentDate = date
    }
}
