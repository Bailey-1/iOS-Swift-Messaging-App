//
//  GroupMembersViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class GroupMembersViewController: UITableViewController {
    
    var chatMembersModel = GroupMembersModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // basic config for chatMembersModel
        chatMembersModel.delegate = self
        
        // Call the method to fetch all of the members of the current chat
        chatMembersModel.loadMembers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: K.navController.largeTextColour]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: K.navController.largeTextColour]
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.row)!")
        chatMembersModel.selectedRow = indexPath.row
        self.performSegue(withIdentifier: K.segue.showMemberView, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMembersModel.members.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = chatMembersModel.members[indexPath.row].email
        cell.detailTextLabel!.text = chatMembersModel.members[indexPath.row].name
        
        // Update the colour of the cell from the user set colour and set text to contrast
        if let safeColour = chatMembersModel.members[indexPath.row].colour {
            cell.backgroundColor = UIColor(hexString: safeColour)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: safeColour)!, isFlat: true)
            cell.detailTextLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: safeColour)!, isFlat: true)
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showMemberView {
            let destinationVC = segue.destination as! MemberViewViewController //Chose the right view controller. - Downcasting
            if let safeChatId = chatMembersModel.chatId {
                destinationVC.memberViewModel.chatId = safeChatId
                destinationVC.memberViewModel.memberId = chatMembersModel.members[chatMembersModel.selectedRow!].email
            }
        }
    }
}

//MARK: - GroupMembersViewController: GroupMembersModelDelegate

extension GroupMembersViewController: GroupMembersModelDelegate {
    func updateTitle(title: String) {
        self.title = title
    }
    
    // Allow the model to update the tableview remotely
    func updateTableView() {
        tableView.reloadData()
    }
}
