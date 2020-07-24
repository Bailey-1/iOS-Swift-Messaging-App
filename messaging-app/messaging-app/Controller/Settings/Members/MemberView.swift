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
    
    @IBOutlet weak var nameValueLabel: UILabel!
    @IBOutlet weak var usernameValueLabel: UILabel!
    @IBOutlet weak var colourValueLabel: UILabel!
    
    var memberViewModel = MemberViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memberViewModel.delegate = self
        
        print("User: \(memberViewModel.memberId!)")
        memberViewModel.loadMember()
    }
    
    // Show a popup to allow the user to change the username of one of the members in the chat
    func showChangeUsernameAlert() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Change Username", message: "Change the displayed name for this user in this chat.", preferredStyle: .alert)
        
        // Runs when add item button is pressed
        let action = UIAlertAction(title: "Change", style: .default) { (action) in
            if let safeText = textField.text {
                self.memberViewModel.updateUserName(newUserName: safeText)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            // Empty on purpose
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segue.showColourPicker {
            let destinationVC = segue.destination as! ColourPicker //Chose the right view controller. - Downcasting
            destinationVC.delegate = self
        }
    }
    
    //MARK: - tableView Methods
    
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
}

//MARK: - MemberView: GroupControlDelegate

extension MemberView: ColourPickerDelegate {
    func useColour(colour: String) {
        print("MemberView has the colour \(colour)")
        memberViewModel.updateUserColour(with: colour)
    }
}

//MARK: - MemberView: MemberViewModelDelegate

extension MemberView: MemberViewModelDelegate {
    func showMemberDetails(name: String, userName: String, colour: String) {
        DispatchQueue.main.async {
            self.nameValueLabel.text = name
            self.usernameValueLabel.text = userName
            self.colourValueLabel.text = colour
        }
    }
}
