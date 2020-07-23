//
//  AddUser.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class AddUser: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    var totalUsers: [User] = []
    var possibleUsers: [User] = []
    
    var chatId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadUsers()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        print(sender.text!)
        let searchValue = sender.text!
        
        possibleUsers = searchValue == "" ? totalUsers : totalUsers.filter {$0.email!.contains(searchValue) }
        tableView.reloadData()
    }
    
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
                self.tableView.reloadData()
            }
        }
    }
    
    func addNewUser(user: User) {
        if let safeChatId = chatId {
            // Add email to the user array in the chat document
            db.collection("conversations").document(safeChatId)
                .setData([ "users": FieldValue.arrayUnion([user.email!])], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
            
            // Add all details to document in user collection
            db.collection("conversations").document(safeChatId).collection("users").document(user.email!).setData([
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
}

//MARK: - AddUser - UITableViewDataSource

extension AddUser: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = possibleUsers[indexPath.row].email
        cell.detailTextLabel!.text = possibleUsers[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        addNewUser(user: possibleUsers[indexPath.row])
    }
}
