//
//  ContactsViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import FirebaseFirestoreSwift
import Firebase

class ContactsViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var currentUser: User?
    
    var conversations: [Conversation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get current user data
        let a = Auth.auth().currentUser
        if let user = a {
            currentUser = user
            
            // get conversations with user email in
            let conversationRef = db.collection("conversations").whereField("users", arrayContains: user.email!)
            
            // Get all documents and loop through them
            conversationRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("There has been an error \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("Chat Name: \(document.data()["name"] as! String)")
                        
                        var newConversation = Conversation()
                        newConversation.id = document.documentID
                        newConversation.name = document.data()["name"] as! String
                        self.conversations.append(newConversation)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

extension ContactsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = conversations[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ID: \(conversations[indexPath.row].id) - Name: \(conversations[indexPath.row].name)")
    }
}
