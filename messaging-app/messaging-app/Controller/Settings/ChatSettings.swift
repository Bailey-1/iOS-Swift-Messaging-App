//
//  ChatSettings.swift
//  messaging-app
//
//  Created by Bailey Search on 22/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class ChatSettings: UITableViewController {
    
    var chatId: String = ""
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chat ID: \(chatId)")
    }
    
    // Set new VC variables to pass chatID etc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showColourPicker {
            let destinationVC = segue.destination as! ColourPicker //Choose the right view controller. - Downcasting
            destinationVC.delegate = self
            
        } else if segue.identifier == K.segue.showChatMembers {
            let destinationVC = segue.destination as! GroupMembers //Choose the right view controller. - Downcasting
            destinationVC.chatId = chatId
        }
    }
}

//MARK: - ChatSettings: GroupColourDelegate

extension ChatSettings: ColourPickerDelegate {
    func useColour(colour: String) {
        // TODO - Move this to a model class
        print(colour)
        print("ChatSettings - ColourPickerDelegate")
        
        db.collection("conversations").document(chatId).setData([ "colour": colour], merge: true) { error in
            if let safeError = error {
                print("An error occured: \(safeError)")
            } else {
                print("Success")
            }
        }
    }
}
