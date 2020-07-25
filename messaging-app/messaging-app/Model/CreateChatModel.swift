//
//  CreateChatModel.swift
//  messaging-app
//
//  Created by Bailey Search on 25/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

class CreateChatModel {
    
    let db = Firestore.firestore()
    
    func newChat(withName name: String) {
        createBaseChatDocument(chatName: name)
        createChatUserCollection()
    }
    
    // Create the basic document with the default variables
    func createBaseChatDocument(chatName: String) {
        db.collection(K.db.collection.chats).addDocument(data: [
            "name": chatName,
            "colour": K.db.defaults.chatColour,
            "time": FieldValue.serverTimestamp()
        ]) { (error) in
            if let e = error {
                print("Error with saving new chat to firestore")
                print(e)
            } else {
                print("Success with saving new chat to firestore")
            }
        }
    }
    
    // Create the collection and add the chat creator to the collection
    func createChatUserCollection() {
        
    }
}
