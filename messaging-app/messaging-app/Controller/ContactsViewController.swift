//
//  ContactsViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {
                    
    let chatManager = ChatManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        chatManager.loadChats()
        chatManager.delegate = self
        tableView.rowHeight = 80
     }

    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let signOutSuccess = chatManager.signUserOut()
        if signOutSuccess {
            navigationController?.popToRootViewController(animated: true)
        } else {
            fatalError("User sign out error has occured")
        }
    }
}

//MARK: - UITableViewDelegate Stuff
extension ContactsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatManager.conversations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = chatManager.conversations[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ID: \(chatManager.conversations[indexPath.row].id) - Name: \(chatManager.conversations[indexPath.row].name)")
        chatManager.selectedChatId = chatManager.conversations[indexPath.row].id
        self.performSegue(withIdentifier: K.segue.showMessages, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showMessages {
            let destinationVC = segue.destination as! MessagesViewController //Chose the right view controller. - Downcasting
            if let safeChatId = chatManager.selectedChatId {
                destinationVC.chatId = safeChatId
            }
        }
    }
}

extension ContactsViewController: ChatManagerDelegate {
    func updateViewTable() {
        tableView.reloadData()
    }
}
