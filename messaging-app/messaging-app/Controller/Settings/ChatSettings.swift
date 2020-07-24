//
//  ChatSettings.swift
//  messaging-app
//
//  Created by Bailey Search on 22/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class ChatSettings: UITableViewController {

    var chatSettingsManager = ChatSettingsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Set new VC variables to pass chatID etc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showColourPicker {
            let destinationVC = segue.destination as! ColourPicker //Choose the right view controller. - Downcasting
            destinationVC.delegate = self
            
        } else if segue.identifier == K.segue.showChatMembers {
            let destinationVC = segue.destination as! GroupMembers //Choose the right view controller. - Downcasting
            destinationVC.groupMembersModel.chatId = chatSettingsManager.chatId
            
        } else if segue.identifier == K.segue.showAddUser {
            let destinationVC = segue.destination as! AddUser //Choose the right view controller. - Downcasting
            if let safeChatId = chatSettingsManager.chatId {
                destinationVC.addUserManager.chatId = safeChatId
            }
        }
    }
}

//MARK: - ChatSettings: GroupColourDelegate

extension ChatSettings: ColourPickerDelegate {
    func useColour(colour: String) {
        chatSettingsManager.updateGroupColour(colour: colour)
    }
}
