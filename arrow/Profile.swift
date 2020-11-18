//
//  Profile.swift
//  arrow
//
//  Created by david robertson on 11/16/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Profile: UITableViewController {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getData()
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number = 0
        
        if section == 0 {
            number = 1
        } else if section == 1 {
            number = 2
        }
        
        return number
    }

    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
                do {
                  try firebaseAuth.signOut()
                    
                    self.dismiss(animated: true, completion: nil)
                } catch let signOutError as NSError {
                  print ("Error signing out: %@", signOutError)
                }
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        let uid = Auth.auth().currentUser!.uid
                          let db = Firestore.firestore()
                          db.collection("Players").whereField("uid", isEqualTo: uid).getDocuments() { (querySnapshot, err) in
                            if let err = err {
                              print("Error getting documents: \(err)")
                            } else {
                              for document in querySnapshot!.documents {
                                document.reference.delete()
                          
                              }
                            }
                          }
        user?.delete { error in
          if let error = error {
            // An error happened.
          } else {
           
                self.dismiss(animated: true, completion: nil)
          }
        }
    }
    @IBAction func closeButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getData() {
             let db = Firestore.firestore()
             let user = Auth.auth().currentUser?.uid
             let docRef = db.collection("Players")
             docRef.getDocuments { (snapshot, error) in
                 if error != nil {
                     
                 }
                guard let snap = snapshot?.documents else { return }
                 for doc in snap {
                     let data = doc.data()
                    if data["uid"] as? String ?? "" == user {
                         let fullName = data["FullName"] as? String ?? ""
                         let email = data["Email"] as? String ?? ""
                         let highscore = data["HighScore"] as? Int ?? 0
                         
                        
                        self.fullNameLabel.text = fullName
                        self.emailLabel.text = email
                        self.highScoreLabel.text = "Highscore: \(String(highscore))"
                    }
                    
                   
                    
                 }
                 
                 
         }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
