//
//  ChatSettings.swift
//  messaging-app
//
//  Created by Bailey Search on 22/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class ChatSettings: UITableViewController{
    
    var chatId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Chat ID: \(chatId)")
    }
    
    // Set new VC variables to pass chatID etc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showChangeGroupColour {
            let destinationVC = segue.destination as! GroupColour //Chose the right view controller. - Downcasting
            destinationVC.chatId = chatId
        }
    }
}
