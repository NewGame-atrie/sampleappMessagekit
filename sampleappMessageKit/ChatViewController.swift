//
//  ChatViewController.swift
//  sampleappMessageKit
//
//  Created by 北田菜穂 on 2020/12/03.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatViewController: MessagesViewController{
    
    var messageList: [MessageData] = []
    
    let store : ChatDataStore = ChatDataStore()
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Dummy
        //self.loadMessagesFromFirebase()
        /*
        DispatchQueue.main.async {
            // messageListにメッセージの配列をいれて
            self.messageList = self.getMessages()
            // messagesCollectionViewをリロードして
            self.messagesCollectionView.reloadData()
            // 一番下までスクロールする
            self.messagesCollectionView.scrollToBottom()
        }
         */
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        self.messageInputBar.delegate = self
        
        self.scrollsToBottomOnKeyboardBeginsEditing = true
        self.maintainPositionOnKeyboardFrameChanged = true
        
        store.readChat(self)
    }
    
    //Dummy
    func getMessages() -> [MessageData]{
        return [
            createMessage(text:"A"),
            createMessage(text: "あ"),
            createMessage(text: "b"),
            createMessage(text: "い"),
        ]
    }
    
    func createMessage(text:String, _ sendFromMe : Bool = false) -> MessageData{
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
            date: Date())
    }
}

//
extension ChatViewController: MessagesDataSource{
    
    //自分のID
    //Dummy
    func currentSender() -> SenderType {
        return Sender(senderId: "123", displayName: "Me")
    }
    
    //相手のID
    //Dummy
    func otherSender() -> SenderType{
        return Sender(senderId: "456", displayName: "You")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messageList[indexPath.section]
    }
    

    
    // メッセージの上に文字を表示
       func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//           if indexPath.section % 3 == 0 {
//               return NSAttributedString(
//                      string: MessageKitDateFormatter.shared.string(from: message.sentDate),
//                      attributes: [
//                            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
//                            NSAttributedString.Key.foregroundColor: UIColor.darkGray
//                          ])
//           }
           return nil
       }

       // メッセージの上に文字を表示（名前）
       func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            let name = message.sender.displayName
        
            return NSAttributedString(
                string: name,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)
                ])
       }

       // メッセージの下に文字を表示（日付）
       func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
            let dateString = formatter.string(from: message.sentDate)
        
            return NSAttributedString(
                string: dateString,
                attributes: [
                    NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)
                ])
       }
    
}

// メッセージのdelegate
extension ChatViewController: MessagesDisplayDelegate {

    // メッセージの色を変更（デフォルトは自分：白、相手：黒）
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }

    // メッセージの背景色を変更している（デフォルトは自分：緑、相手：グレー）
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ?
            UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) :
            UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

    // メッセージの枠にしっぽを付ける
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }

    // アイコンをセット
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = Avatar(initials: "人")
        avatarView.set(avatar: avatar)
    }
}


// 各ラベルの高さを設定（デフォルト0なので必須）
extension ChatViewController: MessagesLayoutDelegate {

    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 { return 10 }
        return 0
    }

    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }

    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension ChatViewController: MessageCellDelegate {
    // メッセージをタップした時の挙動
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    // メッセージ送信ボタンをタップした時の挙動
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String){
        
        
        store.send(text: text)
        
        
        let attributedText = NSAttributedString(
                    string: text,
                    attributes: [
                        .font: UIFont.systemFont(ofSize: 15),
                        .foregroundColor: UIColor.white
                    ]
                )
                
                //自分から送信する
                let message = MessageData(
                    kind: .attributedText(attributedText),
                    sender: currentSender(),
                    messageId: UUID().uuidString,
                    date: Date()
                )
                
                //データにMessageDataのデータを追加
                messageList.append(message)
                
                //insertSectionでデータを更新
                messagesCollectionView.insertSections([messageList.count - 1])
                
                //テキストを空にする
                inputBar.inputTextView.text = nil
                
                //スクロール
                messagesCollectionView.scrollToBottom()
        
        
        }
    }

