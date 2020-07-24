//
//  MemberViewModel.swift
//  messaging-app
//
//  Created by Bailey Search on 24/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

protocol MemberViewModelDelegate {
    func showMemberDetails(name: String, userName: String, colour: String)
}

class MemberViewModel {
    let db = Firestore.firestore()
    var chatId: String?
    var memberId: String?
    
    var delegate: MemberViewModelDelegate?
    
    func loadMember() {
        if let safeChatId = chatId, let safeMemberId = memberId {
            db.collection("conversations").document(safeChatId).collection("users").document(safeMemberId).addSnapshotListener { (document, err) in
                if let err = err {
                    print("Error getting document: \(err)")
                } else {
                    print("Success getting document")
                    let name = (document?.data()!["name"] as! String)
                    let userName = (document?.data()!["userName"] as! String)
                    let colour = (document?.data()!["colour"] as! String)
                    self.delegate?.showMemberDetails(name: name, userName: userName, colour: colour)
                }
            }
        }
    }
    
    func updateUserColour(with colour: String) {
        if let safeChatId = chatId, let safeMemberId = memberId {
            db.collection("conversations").document(safeChatId).collection("users").document(safeMemberId).setData([ "colour": colour], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
        }
    }
    
    func changeUserName(newUserName: String) {
        if let safeChatId = self.chatId, let safeMemberId = self.memberId {
            self.db.collection("conversations").document(safeChatId).collection("users").document(safeMemberId).setData([ "userName": newUserName], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
        }
    }
}
