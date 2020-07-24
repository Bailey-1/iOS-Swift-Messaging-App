//
//  ChatManager.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

protocol ChatManagerDelegate {
    func updateViewTable()
}

class ChatManager {
    let db = Firestore.firestore()
    
    let currentUser = Auth.auth().currentUser
    
    var delegate: ChatManagerDelegate?
    
    var chats: [Chat] = []
    var selectedChatId: String?
    
    // Get all chats and add then to chats
    func loadChats() {
        if let safeEmail = currentUser?.email {
            let conversationRef = db.collection(K.db.collection.chats).whereField("users", arrayContains: safeEmail)
            
            conversationRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There has been an error \(error)")
                } else {
                    
                    // Loop through each chat where the current user email is saved
                    
                    for chat in querySnapshot!.documents {
                        print("Chat Name: \(chat.data()["name"] as! String)")
                        
                        var newConversation = Chat()
                        newConversation.id = chat.documentID
                        newConversation.name = chat.data()["name"] as! String
                        self.chats.append(newConversation)
                    }
                    self.delegate?.updateViewTable()
                }
            }
        }
    }
    
    // Sign the current user out
    func signUserOut() -> Bool {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            return true
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            return false
        }
    }
}
