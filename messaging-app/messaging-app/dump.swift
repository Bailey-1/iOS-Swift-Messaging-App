//
//  dump.swift
//  messaging-app
//
//  Created by Bailey Search on 21/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import Foundation

//        // Select document from collection
//        let docRef = db.collection("users").document(currentUser!.email!).collection("friends")
//
//        docRef.getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("Friend: \(document.documentID) - ChatId: \(document.data()["chatId"] as! String)")
//                }
//            }
//
//        }
        
        // Use getdocument to fetch data
//        docRef.getDocument { (document, error) in
//            if let data = document?.data() {
//                print(data["friends"] ?? "Friends not available")
//                // Must use a forced downcast because swift doesn't know what the data type will be and if it is a sequence
//                for friend in data["friends"] as! [String] {
//                    print(friend)
//
//                    let friendDocRef = self.db.collection("users").document(friend)
//
//                    friendDocRef.getDocument { (document, error) in
//                        if let data = document?.data() {
//                            print(data["name"] as! String)
//                        }
//                    }
//
//                }
//
//            }
//        }
