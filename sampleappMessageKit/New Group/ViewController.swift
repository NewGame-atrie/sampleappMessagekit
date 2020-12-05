//
//  ViewController.swift
//  sampleappMessageKit
//
//  Created by 北田菜穂 on 2020/12/03.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ViewController: MessagesViewController {
    
    var messageList: [MessageData] = []
        
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
        
        self.scrollsToBottomOnKeyboardBeginsEditing = true
        self.maintainPositionOnKeyboardFrameChanged = true
        
        self.loadData()
    }
    
    func getMessages(){
        
        //@TODO Firebaseからデータを読み込む
        
        // messageListにメッセージの配列をいれて
        self.messageList = [
            createMessage(text: "あ"),
            createMessage(text: "い", true),
            createMessage(text: "う"),
            createMessage(text: "え", true),
            createMessage(text: "お"),
            createMessage(text: "か", true),
            createMessage(text: "き"),
            createMessage(text: "く", true),
            createMessage(text: "け"),
            createMessage(text: "こ", true),
            createMessage(text: "さ"),
            createMessage(text: "し", true),
            createMessage(text: "すせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん"),
        ]
        
        
        DispatchQueue.main.async {
            // messagesCollectionViewをリロードして
            self.messagesCollectionView.reloadData()
            // 一番下までスクロールする
            self.messagesCollectionView.scrollToBottom()
        }

        
    }
    
    //ダミー関数
    func otherSender() -> SenderType {
        //相手のID
        return Sender(senderId: "456", displayName: "B")
    }
    
    func createMessage(text: String, _ sendFromMe : Bool = false) -> MessageData {
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.black
            ])
        
        return MessageData(
            kind: .attributedText(attributedText),
            sender: (sendFromMe) ? currentSender() : otherSender(),
            messageId: UUID().uuidString,
            date: Date()
        )
    }
    
    
    
}

extension ViewController : MessagesDataSource {
    
    func currentSender() -> SenderType {
        //firebaseのIDをsenderIdに入れる
        //displayNameは自分の名前
        //@TODO firebaseから値を取り込む
        return Sender(senderId: myId, displayName: "あなた")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    
    // メッセージの上に文字を表示
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        if indexPath.section % 3 == 0 {
//            return NSAttributedString(
//                string: MessageKitDateFormatter.shared.string(from: message.sentDate),
//                attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//                             NSAttributedString.Key.foregroundColor: UIColor.darkGray]
//            )
//        }
        return nil
    }

    // メッセージの上に文字を表示（名前）
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let name = message.sender.displayName
        
        if message.sender.senderId == self.myId {
            return nil
        }
        
        return NSAttributedString(
            string: name,
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)
            ]
        )
    }

    // メッセージの下に文字を表示（日付）
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
//        if message.isSending {
//            return NSAttributedString(
//                string: "通信中",
//                attributes: [
//                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)
//                ]
//        }
        
        let dateString = formatter.string(from: message.sentDate)
        
        return NSAttributedString(
            string: dateString,
            attributes: [
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)
            ]
        )
    }
}

extension ViewController: MessagesDisplayDelegate {
    
    // メッセージの枠にしっぽを付ける
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    // アイコンをセット
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        let firstName = isFromCurrentSender(message: message)
            ? "YOU"
            : message.sender.displayName.prefix(1)
        let avatar = Avatar(initials: String(firstName))
        avatarView.set(avatar: avatar)
        
    }
    
}


extension ViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        //if indexPath.section % 3 == 0 { return 10 }
        return 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

}

extension ViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        //firebaseにデータを登録する
        //let data = ["text:" text, "sender": self.myId]
//        self.chatRepository.send(data) { result in
//            if result {
//                messageList[messageList.count - 1].isSending = false
//                messagesCollectionView.reloadSections([messageList.count - 1])
//            }else{
//                self.showAlert("通信に失敗しました")
//                messageList.delete(messageList.count - 1)
//                messagesCollectionView.deleteSections([messageList.count - 1])
//            }
//
//        }
        
        //ダミー
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.white
            ]
        )
        
        //自分から送信にする
        let message = MessageData(
            kind: .attributedText(attributedText),
            sender: currentSender(),
            messageId: UUID().uuidString,
            date: Date()
        )
        
        //message.isSending = true
        
        //データに追加
        messageList.append(message)
        
        //insertSectionでデータを更新
        messagesCollectionView.insertSections([messageList.count - 1])
        
        //テキストを空にする
        inputBar.inputTextView.text = nil
        
        //スクロール
        messagesCollectionView.scrollToBottom()
    }
    
}
