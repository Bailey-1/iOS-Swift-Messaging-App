//
//  MemberView.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class MemberView: UITableViewController {
    
    let db = Firestore.firestore()
    var chatId: String?
    var memberId: String?
    
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var colourValueLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User: \(memberId)")
        loadMember()
    }
    
    func loadMember() {
        if let safeChatId = chatId, let safeMemberId = memberId {
            db.collection("conversations").document(safeChatId).collection("users").document(safeMemberId).addSnapshotListener { (document, err) in
                if let err = err {
                    print("Error getting document: \(err)")
                } else {
                    print("Success getting document")
                    DispatchQueue.main.async {
                        self.nameValueLabel.text = (document?.data()!["name"] as? String)
                        self.usernameValueLabel.text = (document?.data()!["userName"] as? String)
                        self.colourValueLabel.text = (document?.data()!["colour"] as? String)
                    }
                }
            }
        }
    }
    
    func showChangeUsernameAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Change Username", message: "Change the displayed name for this user in this chat.", preferredStyle: .alert)
        
        // Runs when add item button is pressed
        let action = UIAlertAction(title: "Change", style: .default) { (action) in
            if let safeChatId = self.chatId, let safeMemberId = self.memberId, let safeText = textField.text {
                self.db.collection("conversations").document(safeChatId).collection("users").document(safeMemberId).setData([ "userName": safeText], merge: true) { error in
                    if let safeError = error {
                        print("An error occured: \(safeError)")
                    } else {
                        print("Success")
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
        }
        
        // Runs as soon as the textfield is created
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Username"
            textField = alertTextField // Extend scope of alertTextField
            
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.row) {
        case 1:
            showChangeUsernameAlert()
            break;
        case 2:
            self.performSegue(withIdentifier: K.segue.showColourPicker, sender: self)
            break;
        default:
            print("Not a valid row")
            break;
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showColourPicker {
            let destinationVC = segue.destination as! ColourPicker //Chose the right view controller. - Downcasting
            destinationVC.delegate = self
        }
    }
}

//MARK: - MemberView: GroupControlDelegate

extension MemberView: ColourPickerDelegate {
    func useColour(colour: String) {
        print("MemberView has the colour \(colour)")
        if let safeChatId = chatId, let safeMemberId = memberId {
            db.collection("conversations").document(safeChatId).collection("users").document(safeMemberId).setData([ "colour": colour], merge: true) { error in
                if let safeError = error {
                    print("An error occured: \(safeError)")
                } else {
                    print("Success")
                }
            }
        }
    }
}
