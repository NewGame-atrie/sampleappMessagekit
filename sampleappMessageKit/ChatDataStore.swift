//
//  DataStore.swift
//  sampleappMessageKit
//
//  Created by 北田菜穂 on 2020/12/05.
//

import Foundation
import Firebase
import FirebaseFirestore

class ChatDataStore {
    
    var username : String = "name"
    var senderId : String = "sender_id"
    
    //メッセージの読み込み
    func readChat(_ chatViewControler : ChatViewController ){
        print("readChatが呼ばれた")
        
        let db = Firestore.firestore()
        
        db.collection("messages").order(by: "send_date", descending: false).getDocuments(completion: {
            (result, err) in
            
            if let err = err {
                print("faild to read document \(err)")
                return
            }
            
            guard let snapshot = result else {
                print("snapshot is nil")
                return
            }
            
            var messageList: [MessageData] = []
            
            for document in snapshot.documents {
                let data = document.data()
                let name : String = data["name"] as? String ?? ""
                let senderId : String = data["sender_id"] as? String ?? ""
                let text : String = data["text"] as? String ?? ""
                print("document: \(name) \(senderId) \(text)")
                
                let senderFromMe = (senderId == "sender_id")
                let message = chatViewControler.createMessage(text: text, senderFromMe)
                messageList.append(message)
            }
            
            DispatchQueue.main.async {
                // messageListにメッセージの配列をいれて
                chatViewControler.messageList = messageList
                // messagesCollectionViewをリロードして
                chatViewControler.messagesCollectionView.reloadData()
                // 一番下までスクロールする
                chatViewControler.messagesCollectionView.scrollToBottom()
            }
            
        })
        
        
    }
    
    //メッセージの送信
    //textは内容の呼び出し
    func send(text:String){
        
        let db = Firestore.firestore()
        
        db.collection("messages").addDocument(data: [
            "name" : self.username,
            "sender_id" : self.senderId,
            "text" : text,
            "send_date" : Date()
        ]) { err in
            if let err = err {
                print("faild to add document \(err)")
            }
        }
    }
}
