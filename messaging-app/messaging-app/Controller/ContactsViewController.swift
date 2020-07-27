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
        chatManager.delegate = self
        chatManager.loadChats()
        
        tableView.rowHeight = 80
     }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: K.navController.largeTextColour]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: K.navController.largeTextColour]
        navigationController?.navigationBar.tintColor = K.navController.secondaryTextColour
    }

    //TODO: Move this to a proper settings area
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
        return chatManager.chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = chatManager.chats[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("ID: \(chatManager.chats[indexPath.row].id) - Name: \(chatManager.chats[indexPath.row].name)")
        chatManager.selectedChatId = chatManager.chats[indexPath.row].id
        self.performSegue(withIdentifier: K.segue.showMessages, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
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
