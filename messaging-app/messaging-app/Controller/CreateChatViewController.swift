//
//  CreateGroup.swift
//  messaging-app
//
//  Created by Bailey Search on 24/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit

class CreateChatViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var createChatModel = CreateChatModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        if nameTextField.text != nil {
            createChatModel.newChat(withName: nameTextField.text!)
        }
    }
}
