//
//  RegisterViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if let safeEmail = email, let safePassword = password {
            // Try to create a new user
            Auth.auth().createUser(withEmail: safeEmail, password: safePassword) { authResult, error in
                if let e = error {
                    //print(e)
                    
                    //TODO: Add error handling show alerts or something
                    if let errCode = AuthErrorCode(rawValue: e._code) {
                        switch errCode {
                        case .invalidEmail:
                            print("invalid email")
                        case .emailAlreadyInUse:
                            print("Email already in use")
                        case .weakPassword:
                            print("Please use a stronger password")
                        default:
                            print("Error other")
                        }
                        print("localizedDescription: \(error!.localizedDescription)")
                    }
                } else {
                    // Authentication success
                    print(authResult!)
                    
                    // Defines basic data for the user
                    self.db.collection("users").document(self.emailTextField.text!).setData([
                        "name": "Null Name",
                        "email": self.emailTextField.text!,
                        "friends": []
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    self.performSegue(withIdentifier: K.segue.showContactsFromRegister, sender: self)
                }
            }
        }
    }
}
