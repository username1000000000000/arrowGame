//
//  SignUp.swift
//  arrow
//
//  Created by david robertson on 11/16/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class SignUp: UIViewController {

    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        firstNameField.layer.cornerRadius = 2.5
        lastNameField.layer.cornerRadius = 2.5
        emailField.layer.cornerRadius = 2.5
        passwordField.layer.cornerRadius = 2.5
        
        
    }
    @IBAction func continueButtonPressed(_ sender: UIBarButtonItem) {
        if firstNameField.text != "" || lastNameField.text != "" || emailField.text != "" || passwordField.text != ""  {
            signUp()
        } else {
            print("Cant sign up")
        }
    }
    func signUp() {
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (AuthResult, error) in
            
            if error != nil {
                
            }
            if AuthResult != nil {
                let player = Player(firstName: self.firstNameField.text!,
                                             lastName: self.lastNameField.text!,
                                             uid: AuthResult!.user.uid,
                                             email: self.emailField.text!)
                         player.highScore = 0
                         let data: [String: Any] = ["FirstName": player.firstName,
                                                    "LastName": player.lastName,
                                                    "FullName": player.fullName,
                                                    "uid": player.uid,
                                                    "HighScore": player.highScore,
                                                    "Email": player.email]
                         var db = Firestore.firestore()
                db.collection("Players").document((AuthResult?.user.uid)!).setData(data)
                         self.transition()
            }
         
        }
    }
    func transition() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Navigation") as UINavigationController
        vc.modalPresentationStyle = .fullScreen
        navigationController?.present(vc, animated: true, completion: nil
        )
    }
    

    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Navigation") as! UINavigationController
               vc.modalPresentationStyle = .fullScreen
               self.present(vc, animated: true, completion: nil)
    }
    
  

}
