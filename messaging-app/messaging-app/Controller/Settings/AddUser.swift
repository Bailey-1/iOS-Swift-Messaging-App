//
//  AddUser.swift
//  messaging-app
//
//  Created by Bailey Search on 23/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class AddUser: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    
    var addUserManager = AddUserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        addUserManager.delegate = self
        addUserManager.loadUsers()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        print(sender.text!)
        let searchValue = sender.text!
        
        addUserManager.updatePossibleUsers(searchValue: searchValue)
    }
}

//MARK: - AddUser - UITableViewDataSource

extension AddUser: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addUserManager.possibleUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = addUserManager.possibleUsers[indexPath.row].email
        cell.detailTextLabel!.text = addUserManager.possibleUsers[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        addUserManager.addNewUser(user: addUserManager.possibleUsers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - AddUser: AddUserManagerDelegate

extension AddUser: AddUserManagerDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
}
