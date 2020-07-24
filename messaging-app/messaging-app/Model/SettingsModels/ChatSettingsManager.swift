//
//  ChatSettings.swift
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
    
    func updateGroupColour(colour: String) {
        if let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).setData([ "colour": colour], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
        }
    }
}
