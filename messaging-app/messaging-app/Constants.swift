//
//  Constants.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

struct K {
    static let messageCellIdentifier = "messageCellIdentifier"
    static let messageCellNib = "MessageBubble"
    
    struct db {
        struct collection {
            //todo: rename this in the firestore
            static let chats = "conversations"
        }
    }
    
    struct segue {
        static let showContactsFromRegister = "showContactsFromRegister"
        static let showContactsFromLogin = "showContactsFromLogin"
        
        static let showMessages = "showMessages"
        
        static let showChatSettings = "showChatSettings"
        static let showColourPicker = "showColourPicker"
        static let showChatMembers = "showChatMembers"
        static let showMemberView = "showMemberView"
        
        static let showAddUser = "showAddUser" 
    }
    
    struct colours {
        static let startUpMenu = [
        UIColor(hexString: "787FF6")!,
        UIColor(hexString: "4ADEDE")!]

    }
}
