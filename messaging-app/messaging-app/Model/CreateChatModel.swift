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
    
    var newChatRef: DocumentReference?
    
    func newChat(withName name: String) {
        createBaseChatDocument(chatName: name)
        createChatUserCollection()
    }
    
    // Create the basic document with the default variables
    func createBaseChatDocument(chatName: String){
        // Create a new document and save the reference
        newChatRef = db.collection(K.db.collection.chats).document()
        
        // Create the base document for the chat with data
        if let safeDocumentRef = newChatRef {
            safeDocumentRef.setData([
                "name": chatName, // Set name
                "colour": K.db.defaults.chatColour, // Set chat colour
                "timeCreated": FieldValue.serverTimestamp(), // Set time created
                "users": [Auth.auth().currentUser?.email] // Set the user array with the only user email in it.
            ]) { (error) in
                if let e = error {
                    print("Error with saving new chat to firestore")
                    print(e)
                } else {
                    print("Success with saving new chat to firestore")
                }
            }
        }
    }
    
    // Create the collection and add the chat creator to the collection within the chat document
    func createChatUserCollection() {
        if let safeDocumentRef = newChatRef {
            safeDocumentRef.collection("users").document((Auth.auth().currentUser?.email)!).setData([
                "name": "", //TODO: Add name value to user collection documents and to the register process so i can reference that here easily.
                "nickName": "",
                "colour": K.db.defaults.userColour,
                "timeAdded": FieldValue.serverTimestamp()
            ])
        }
    }
}
