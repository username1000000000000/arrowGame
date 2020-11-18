//
//  Login.swift
//  arrow
//
//  Created by david robertson on 11/17/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class Login: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailField.layer.cornerRadius = 2.5
        passwordField.layer.cornerRadius = 2.5
    }
    
    @IBAction func continueButtonPressed(_ sender: UIBarButtonItem) {
        if emailField.text != "" || passwordField.text != "" {
            self.signIn()
        } else {
            print("Cant sign in")
        }
    }
    func signIn() {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (AuthResult, error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
            if AuthResult != nil {
                print("Signed in successfully")
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
    
    @IBAction func resetPasswordButtonPressed(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailField.text!) { (error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
