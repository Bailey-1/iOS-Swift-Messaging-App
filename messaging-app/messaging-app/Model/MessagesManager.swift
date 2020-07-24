//
//  MessagesManager.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

protocol MessagesManagerDelegate {
    func updateUI(hexColour: String)
    func updateTitle(title: String)
    func updateMessages()
}

class MessagesManager {
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    var userOptions: [String: String] = [:]
    var chatId: String?
    
    var delegate: MessagesManagerDelegate?
    
    func loadTitle() {
        var result: String = ""
        if let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).getDocument(completion: { (DocumentSnapshot, Error) in
                result = DocumentSnapshot?.data()!["name"] as! String
                self.delegate?.updateTitle(title: result)
            })
        }
    }
    
    func loadChatOptions() {
        loadTitle()
        var hexColourString = "ffffff"

        if let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    // print(querySnapshot?.data())
                    let colour = querySnapshot?.data()!["colour"] as? String
                    if let safeColour = colour {
                        hexColourString = safeColour
                    }
                }
                self.delegate?.updateUI(hexColour: hexColourString)
            }
        }
    }
    
    func loadMessageColour(row: Int) -> String {
        var messageColour = "0A82E1"
        
        if userOptions[messages[row].fromEmail] != "" {
            messageColour = userOptions[messages[row].fromEmail] ?? "0A82E1"
        }
        
        return messageColour
    }
    
    func loadUserOptions() {
        if let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).collection("users").addSnapshotListener { (documents, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in documents!.documents {
                        self.userOptions[document.documentID] = (document.data()["colour"] as? String)
                    }
                    self.loadMessages()
                }
            }
            
        }
    }
    
    func sendMessage(message: String) {
        if let fromEmail = Auth.auth().currentUser?.email, let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).collection("messages").addDocument(data: [
                "fromEmail": fromEmail,
                "text": message,
                "time": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Error with saving data to firestore")
                    print(e)
                } else {
                    print("Success with saving data to firestore")
                }
            }
        }
    }
    
    func loadMessages() {
        if let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).collection("messages").order(by: "time", descending: true).addSnapshotListener { (querySnapshot, err) in
                self.messages = []
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for message in querySnapshot!.documents {
                        print("Message ID: \(message.documentID) - Message Content")
                        
                        var newMessage = Message()
                        newMessage.id = message.documentID
                        newMessage.text = message.data()["text"] as! String
                        newMessage.fromEmail = message.data()["fromEmail"] as! String
                        newMessage.time = message.data()["time"] as? Timestamp

                        self.messages.append(newMessage)
                        self.delegate?.updateMessages()
                    }
                    
                }
            }
        }
    }
}
