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
    
    var conversations: [Conversation] = []
    var selectedChatId: String?
    
    func loadChats() {
        // Get all documents and loop through them
        if let safeEmail = currentUser?.email {
            let conversationRef = db.collection("conversations").whereField("users", arrayContains: safeEmail)
            
            conversationRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There has been an error \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("Chat Name: \(document.data()["name"] as! String)")
                        
                        var newConversation = Conversation()
                        newConversation.id = document.documentID
                        newConversation.name = document.data()["name"] as! String
                        self.conversations.append(newConversation)
                    }
                    self.delegate?.updateViewTable()
                }
            }
        }
    }
    
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
