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
    @IBOutlet weak var chatSettingsButton: UIBarButtonItem!
    
    @IBOutlet weak var senderView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(conversationID)
        
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: K.messageCellNib, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        loadChatOptions()
        loadMessages()
        db.collection("conversations").document(conversationID).getDocument(completion: { (DocumentSnapshot, Error) in
            self.title = DocumentSnapshot?.data()!["name"] as? String
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
//
//        let bar = UINavigationBarAppearance()
//        bar.configureWithDefaultBackground()
//        navBar.standardAppearance = bar
//        navBar.compactAppearance = bar
//        navBar.scrollEdgeAppearance = bar
    }
    
    func updateUI(with hexColour: String) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        navBar.tintColor = UIColor(hexString: hexColour)
        senderView.backgroundColor = UIColor(hexString: hexColour)
        sendButton.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: hexColour)!, isFlat: true)
    }
    
    func loadChatOptions() {
        db.collection("conversations").document(conversationID).addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // print(querySnapshot?.data())
                let colour = querySnapshot?.data()!["colour"] as? String
                if let safeColour = colour {
                    self.updateUI(with: safeColour)
                }
            }
        }
    }
    
    func loadMessages() {
        db.collection("conversations").document(conversationID).collection("messages").order(by: "time", descending: true).addSnapshotListener { (querySnapshot, err) in
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
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    }
                }

            }
        }
    }
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if messageTextField.text != "" {
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
    
    @IBAction func chatSettingsButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.segue.showChatSettings, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showChatSettings {
            let destinationVC = segue.destination as! ChatSettings //Chose the right view controller. - Downcasting
            destinationVC.chatId = conversationID
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
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
