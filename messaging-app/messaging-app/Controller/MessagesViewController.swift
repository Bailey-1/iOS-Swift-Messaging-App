//
//  MessagesViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController {

    let db = Firestore.firestore()
    var conversationID: String = ""
    var messages: [Message] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(conversationID)
        
        
        tableView.dataSource = self
        //tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: K.messageCellNib, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        loadMessages()
        db.collection("conversations").document(conversationID).getDocument(completion: { (DocumentSnapshot, Error) in
            self.title = DocumentSnapshot?.data()!["name"] as? String
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}

        let bar = UINavigationBarAppearance()
        bar.configureWithDefaultBackground()
        navBar.standardAppearance = bar
        navBar.compactAppearance = bar
        navBar.scrollEdgeAppearance = bar
    }
    
    func loadMessages(){
        db.collection("conversations").document(conversationID).collection("messages").order(by: "time", descending: false).addSnapshotListener { (querySnapshot, err) in
            self.messages = []
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for message in querySnapshot!.documents {
                    print("Message ID: \(message.documentID) - Message Content")
                    
                    var newMessage = Message()
                    newMessage.id = message.documentID
                    newMessage.text = message.data()["text"] as! String
                    newMessage.fromEmail = message.data()["fromEmail"] as! String
                    newMessage.time = message.data()["time"] as? Timestamp
                    self.messages.append(newMessage)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let messageContent = messageTextField.text, let fromEmail = Auth.auth().currentUser?.email {
            db.collection("conversations").document(conversationID).collection("messages").addDocument(data: [
                "fromEmail": fromEmail,
                "text": messageContent,
                "time": Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("Error with saving data to firestore")
                    print(e)
                } else {
                    print("Success with saving data to firestore")
                    
                    // Run on the main thread since it updates UI
                    DispatchQueue.main.async{
                        self.messageTextField.text = ""
                    }
                }
            }
        }
    }
}

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier, for: indexPath) as! MessageBubble
        cell.nameLabel.text = messages[indexPath.row].fromEmail
        cell.textContent.text = messages[indexPath.row].text
        
        //cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}
