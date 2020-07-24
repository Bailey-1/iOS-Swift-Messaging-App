//
//  LoginViewController.swift
//  messaging-app
//
//  Created by Bailey Search on 20/07/2020.
//  Copyright © 2020 Bailey Search. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        backgroundView.backgroundColor = UIColor(gradientStyle: .topToBottom, withFrame: backgroundView.frame, andColors: K.colours.startUpMenu)
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if let safeEmail = email, let safePassword = password {
            Auth.auth().signIn(withEmail: safeEmail, password: safePassword) { authResult, error in
                if let e = error {
                    print(e)
                    
                    if let errCode = AuthErrorCode(rawValue: e._code) {
                        switch errCode {
                        case .wrongPassword:
                            print("Wrong password")
                        case .userNotFound:
                            print("No such user account")
                        default:
                            print("Error other")
                        }
                        print("localizedDescription: \(error!.localizedDescription)")
                    }
                    
                } else {
                    self.performSegue(withIdentifier: K.segue.showContactsFromLogin, sender: self)
                }
            }
        }
    }
}
