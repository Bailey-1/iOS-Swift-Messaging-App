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
    
    var members: [User] = []
    let db = Firestore.firestore()
    var chatId: String?

    var selectedRow: Int?
    
    var delegate: GroupMembersModelDelegate?
    
    func loadMembers() {
        if let safeChatId = chatId {
            db.collection("conversations").document(safeChatId).collection("users").getDocuments() { (documents, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for groupMember in documents!.documents {
                        var newUser = User()
                        newUser.email = groupMember.documentID
                        newUser.name = (groupMember.data()["name"] as! String)
                        newUser.userName = (groupMember.data()["userName"] as! String)
                        newUser.colour = (groupMember.data()["colour"] as! String)
                        self.members.append(newUser)
                    }
                    print("done")
                    self.delegate?.updateTitle(title: "Members (\(self.members.count))")
                    self.delegate?.updateTableView()
                }
            }
        }
    }
}
