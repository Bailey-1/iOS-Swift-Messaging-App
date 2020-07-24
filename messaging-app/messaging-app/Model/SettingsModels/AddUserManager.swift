//
//  AddUserManager.swift
//  messaging-app
//
//  Created by Bailey Search on 24/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation
import Firebase

protocol AddUserManagerDelegate {
    func updateTableView()
}

class AddUserManager {
    let db = Firestore.firestore()

    var totalUsers: [User] = []
    var possibleUsers: [User] = []
    
    var chatId: String?
    
    var delegate: AddUserManagerDelegate?
    
    // Load all currently registered users. - this is a bad way to do this but it doesnt matter since theres only a few accounts and i dont want to pay for algolia
    func loadUsers() {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var newUser = User()
                    newUser.email = document.documentID
                    newUser.name = document.data()["name"] as? String
                    newUser.userName = document.data()["userName"] as? String
                    
                    self.totalUsers.append(newUser)
                }
                self.possibleUsers = self.totalUsers
                self.delegate?.updateTableView()
            }
        }
    }
    
    // Add selected user to the current chat
    func addNewUser(user: User) {
        if let safeChatId = chatId {
            // Add email to the user array in the chat document
            db.collection(K.db.collection.chats).document(safeChatId)
                .setData([ "users": FieldValue.arrayUnion([user.email!])], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
            
            // Add all details to document in user collection
            db.collection(K.db.collection.chats).document(safeChatId).collection("users").document(user.email!).setData([
                "name": user.name!,
                "userName": "",
                "colour": "0A82E1"
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        }
    }
    
    // Update possible users based on the current search value
    func updatePossibleUsers(searchValue: String) {
        possibleUsers = searchValue == "" ? totalUsers : totalUsers.filter {$0.email!.contains(searchValue) }
        self.delegate?.updateTableView()
    }
}
