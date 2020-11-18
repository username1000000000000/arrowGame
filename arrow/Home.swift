//
//  Home.swift
//  arrow
//
//  Created by david robertson on 11/16/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class Home: UITableViewController {

    @IBOutlet weak var playNowButton: UIButton!
    @IBOutlet weak var profile: UIButton!
    var players: [Player] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        playNowButton.layer.cornerRadius = 2.5
        profile.layer.cornerRadius = 2.5
        tableView.tableFooterView = UIView()
        navigationController?.navigationBar.shadowImage = UIImage()
        returnAllRegisteredPlayers()
        tableView.rowHeight = 116
    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
         if Auth.auth().currentUser != nil {
                     getData()
            profile.isEnabled = true
               } else {
                   
               
            playNowButton.setTitle("Sign in / Sign up", for: .normal)
            profile.isEnabled = false
               }
         
     }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return players.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! RankCell
        cell.fullNameLabel.text = players[indexPath.row].fullName
        cell.highScoreLabel.text = "Highscore: \(players[indexPath.row].highScore)"
        cell.rankLabel.text = "Rank: \(indexPath.row)"
        
        if indexPath.row > 2 {
            
        } else if indexPath.row == 0 {
            cell.rankLabel.text = "Rank: Champion"
            cell.icon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        } else if indexPath.row == 1 {
            cell.icon.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        } else if indexPath.row == 2 {
            cell.icon.tintColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        }
        
        
    
        return cell
    }
    @IBAction func playNowPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
          let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "GameView") as! GameViewController
            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUp") as! SignUp
            vc.modalPresentationStyle = .fullScreen
            navigationController?.show(vc, sender: self)
            
        }
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
                           let firstName = data["FirstName"] as? String ?? ""
                       
                        
                        self.playNowButton.setTitle("\(firstName), beat your highscore", for: .normal)
                          
                          
                      }
                      
                     
                      
                   }
                   
                   
           }
      }
    
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Profile") as! UINavigationController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    func returnAllRegisteredPlayers() {
        let db = Firestore.firestore()
                  
        let docRef = db.collection("Players").order(by: "HighScore", descending: true)
                   docRef.getDocuments { (snapshot, error) in
                       if error != nil {
                           
                       }
                      guard let snap = snapshot?.documents else { return }
                       for doc in snap {
                           let data = doc.data()
                         
                        let fullName = data["FullName"] as? String ?? ""
                        let firstName = data["FirstName"] as? String ?? ""
                        let lastName = data["LastName"] as? String ?? ""
                        let highScore = data["HighScore"] as? Int ?? 0
                        let email = data["Email"] as? String ?? ""
                        let uid = data["uid"] as? String ?? ""
                        
                        
                        var player = Player(firstName: firstName, lastName: lastName, uid: uid, email: email)
                        
                        player.highScore = highScore
                        self.players.append(player)
                        self.tableView.reloadData()
                        
                       }
                       
                       
               }
    }
    

}
