//
//  ChatSettingsViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 24/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

class ChatSettingsManager {
    var chatId: String?
    let db = Firestore.firestore()
    
    // Update the colour key with a new hex colour
    func updateChatColour(colour: String) {
        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).setData(["colour": colour], merge: true) { err in
                if let err = err {
                    print("An error occured while updating chat colour: \(err)")
                } else {
                    print("Success saving updated chat colour")
                }
            }
        }
    }
}
