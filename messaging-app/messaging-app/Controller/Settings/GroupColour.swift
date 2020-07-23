//
//  GroupColour.swift
//  messaging-app
//
//  Created by Bailey Search on 22/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class GroupColour: UIViewController {
    
    let db = Firestore.firestore()
    var chatId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func colourButtonPressed(_ sender: UIButton) {
        let newColour = sender.backgroundColor?.hexValue()
        
        //TODO - Move this to a model class
        if let safeNewColour = newColour {
            print(safeNewColour)
            db.collection("conversations").document(chatId).setData([ "colour": safeNewColour], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
        }
    }
}

