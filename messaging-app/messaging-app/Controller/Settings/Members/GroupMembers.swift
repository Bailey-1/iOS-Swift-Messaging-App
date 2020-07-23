//
//  GroupMembers.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class GroupMembers: UITableViewController {
    
    var members: [User] = []
    let db = Firestore.firestore()
    var chatId: String?

    var selectedRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMembers()
    }
    
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
                    self.title = "Members (\(self.members.count))"
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        selectedRow = indexPath.row
        self.performSegue(withIdentifier: K.segue.showMemberView, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = members[indexPath.row].email
        cell.detailTextLabel!.text = members[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showMemberView {
            let destinationVC = segue.destination as! MemberView //Chose the right view controller. - Downcasting
            if let safeChatId = chatId {
                destinationVC.chatId = safeChatId
                destinationVC.memberId = members[selectedRow!].email
            }
        }
    }
}
