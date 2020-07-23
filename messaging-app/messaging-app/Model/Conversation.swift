//
//  Conversation.swift
//  messaging-app
//
//  Created by Bailey Search on 21/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

struct Conversation {
    var id: String = ""
    var name: String = ""
    var users: [String] = []
}

struct Message {
    var id: String = ""
    var text: String = ""
    var fromEmail: String = ""
    var time: Timestamp?
}

struct User {
    var email: String?
    var name: String?
    var userName: String?
    var colour: String?
}
