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
    
    var groupMembersModel = GroupMembersModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // basic config for groupMembersModel
        groupMembersModel.delegate = self
        groupMembersModel.loadMembers()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        groupMembersModel.selectedRow = indexPath.row
        self.performSegue(withIdentifier: K.segue.showMemberView, sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMembersModel.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = groupMembersModel.members[indexPath.row].email
        cell.detailTextLabel!.text = groupMembersModel.members[indexPath.row].name
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showMemberView {
            let destinationVC = segue.destination as! MemberView //Chose the right view controller. - Downcasting
            if let safeChatId = groupMembersModel.chatId {
                destinationVC.memberViewModel.chatId = safeChatId
                destinationVC.memberViewModel.memberId = groupMembersModel.members[groupMembersModel.selectedRow!].email
            }
        }
    }
}

//MARK: - GroupMembers: GroupMembersModelDelegate

extension GroupMembers: GroupMembersModelDelegate {
    func updateTitle(title: String) {
        self.title = title
    }
    
    func updateTableView() {
        tableView.reloadData()
    }
}
