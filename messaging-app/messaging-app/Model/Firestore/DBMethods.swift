//
//  DBMethods.swift
//  messaging-app
//
//  Created by Bailey Search on 26/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

class DBMethods {
    
    // Update the last active timestamp when something happens in the chat - so we can order all of the chats based on this asc
    class func updateChatLastActiveTimestamp(chatDocumentID: String) {
        let db = Firestore.firestore()
        db.collection(K.db.collection.chats).document(chatDocumentID).setData([
            "chatLastActive": FieldValue.serverTimestamp()
        ], merge: true) // Use merge or previous data will be overwritten
    }
}
