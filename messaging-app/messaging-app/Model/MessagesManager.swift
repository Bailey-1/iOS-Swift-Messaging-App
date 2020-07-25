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
    var displayName: [String: String] = [:]
    var chatId: String?
    
    var delegate: MessagesManagerDelegate?
    
    // Load the title for the navbar
    func loadTitle() {
        var result: String = ""
        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).getDocument(completion: { (DocumentSnapshot, err) in
                if let err = err{
                    print("Error: Cannot get chat chat title \(err)")
                } else {
                    
                    // Fetch the name for the chat and use it as the title in the navigation controller
                    
                    result = DocumentSnapshot?.data()!["name"] as! String
                    self.delegate?.updateTitle(title: result)
                }
            })
        }
    }
    
    // Load main chat colour
    func loadChatOptions() {
        loadTitle()
        var hexColourString = "ffffff"

        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).addSnapshotListener { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    // Get the current hex colour value set as "colour" in the document
                    
                    let colour = querySnapshot?.data()!["colour"] as? String
                    if let safeColour = colour {
                        hexColourString = safeColour
                    }
                }
                self.delegate?.updateUI(hexColour: hexColourString)
            }
        }
    }
    
    // Return coresponding colour for each message bubble from the sender email.
    func loadMessageColour(row: Int) -> String {
        var messageColour = "0A82E1"
        
        if userOptions[messages[row].fromEmail] != "" {
            messageColour = userOptions[messages[row].fromEmail] ?? "0A82E1"
        }
        
        return messageColour
    }
    
    // Populate dictionary with sender emails and the coresponding colour for their messages to be shown in.
    func loadUserOptions() {
        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).collection("users").addSnapshotListener { (documents, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    // Loop through each user in the current chat
                    
                    for userDocument in documents!.documents {
                        self.userOptions[userDocument.documentID] = (userDocument.data()["colour"] as? String)
                        
                        self.displayName[userDocument.documentID] = userDocument.data()["userName"] as! String != "" ? userDocument.data()["userName"]  as! String : userDocument.data()["name"] as! String
                    }
                    
                    // Now call load messages since message colours have been saved.
                    self.loadMessages()
                }
            }
        }
    }
    
    // Save new message to the database
    func sendMessage(message: String) {
        if let fromEmail = Auth.auth().currentUser?.email, let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).collection("messages").addDocument(data: [
                "fromEmail": fromEmail,
                "text": message,
                "time": FieldValue.serverTimestamp()
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
    
    // Load messages from the database
    func loadMessages() {
        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).collection("messages").order(by: "time", descending: true).addSnapshotListener { (querySnapshot, err) in
                self.messages = []
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    // Loop through each message in the collection and save it to messages array and update delegate
                    
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
