//
//  GroupMembersModel.swift
//  messaging-app
//
//  Created by Bailey Search on 24/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

protocol GroupMembersModelDelegate {
    func updateTitle(title: String)
    func updateTableView()
}

class GroupMembersModel {
    
    var chatMembers: [User] = []
    let db = Firestore.firestore()
    var chatId: String?

    var selectedRow: Int?
    
    var delegate: GroupMembersModelDelegate?
    
    var chatMemberArray: [String]?
    
    func loadValidMembers() {
        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).addSnapshotListener() { (chatDocument, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.chatMemberArray = []
                    self.chatMemberArray = (chatDocument?.data()!["users"] as! [String])
                    self.loadMembers()
                }
            }
        }
    }
    
    // Load all chat chatMembers
    func loadMembers() {
        if let safeChatId = chatId {
            db.collection(K.db.collection.chats).document(safeChatId).collection("users").addSnapshotListener() { (documents, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("Load members snapshot listener else")
                    self.chatMembers = []
                    
                    // Iterates through each member in the chat and adds them to the member array
                    
                    for chatMember in documents!.documents {
                        var newUser = User()
                        newUser.email = chatMember.documentID
                        newUser.name = (chatMember.data()["name"] as? String)
                        newUser.userName = (chatMember.data()["userName"] as? String)
                        newUser.colour = (chatMember.data()["colour"] as! String)
                        
                        if let safeChatMemberArray = self.chatMemberArray {
                            if (safeChatMemberArray.contains(newUser.email!)){
                                self.chatMembers.append(newUser)
                            }
                        }
                    }
                    print("done")
                    self.delegate?.updateTitle(title: "Members (\(self.chatMembers.count))")
                    self.delegate?.updateTableView()
                }
            }
        }
    }
}
