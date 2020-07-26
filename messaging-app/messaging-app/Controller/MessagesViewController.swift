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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatSettingsButton: UIBarButtonItem!
    
    @IBOutlet weak var senderView: UIView!
    
    var messagesManager = MessagesManager()
    
    var chatId: String?
    
    var chatColour: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(chatId ?? "error")
        
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: K.messageCellNib, bundle: nil), forCellReuseIdentifier: K.messageCellIdentifier)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        
        messagesManager.delegate = self
        messagesManager.chatId = chatId
        
        messagesManager.loadUserOptions()
        messagesManager.loadChatOptions()
    }
    
    // Ensure that the chat colour will always appear on this screen regardless of the screens after
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        // Will always fail on the VC first load but will run when VC after is dismissed - resets colours to be consistant
        if let safeChatColour = chatColour {
            navBar.titleTextAttributes = [.foregroundColor: safeChatColour]
            navBar.largeTitleTextAttributes = [.foregroundColor: safeChatColour]
            navBar.tintColor = safeChatColour
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        if let safeMessage = messageTextField.text {
            messagesManager.sendMessage(message: safeMessage)
            //TODO throw error check
            DispatchQueue.main.async{
                self.messageTextField.text = ""
            }
        }
    }
    
    @IBAction func chatSettingsButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: K.segue.showChatSettings, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showChatSettings {
            let destinationVC = segue.destination as! ChatSettingsViewController //Chose the right view controller. - Downcasting
            destinationVC.chatSettingsManager.chatId = chatId
        }
    }
}

//MARK: - MessagesViewController: UITableViewDataSource

extension MessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesManager.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.messageCellIdentifier, for: indexPath) as! MessageBubble
        
        
        cell.nameLabel.text = messagesManager.displayName[messagesManager.messages[indexPath.row].fromEmail]
        cell.textContent.text = messagesManager.messages[indexPath.row].text
        
        let hexCode = messagesManager.loadMessageColour(row: indexPath.row)
        cell.textContent.textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: hexCode)!, isFlat: true)
        cell.viewBubble.backgroundColor = UIColor(hexString: hexCode)
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - MessagesViewController: MessagesManagerDelegate

extension MessagesViewController: MessagesManagerDelegate {
    func updateUI(hexColour: String) {
        let navBar = navigationController?.navigationBar
        
        chatColour = UIColor(hexString: hexColour)!
        navBar?.titleTextAttributes = [.foregroundColor: chatColour!]
        navBar?.largeTitleTextAttributes = [.foregroundColor: chatColour!]
        navBar?.tintColor = chatColour
        
        senderView.backgroundColor = chatColour
        sendButton.tintColor = UIColor(contrastingBlackOrWhiteColorOn: chatColour!, isFlat: true)
    }
    
    func updateTitle(title: String) {
        self.title = title
    }
    
    func updateMessages() {
        self.tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}
