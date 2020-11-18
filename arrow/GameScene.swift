//
//  GameScene.swift
//  arrow
//
//  Created by david robertson on 11/14/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct Category
{
    static let arrow: UInt32 = 0b1
    static let block: UInt32 = 0b10
    static let pointsBlock: UInt32 = 0b100
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var arrow = SKSpriteNode()
     var points = 0
    var lives = 0
    var vc: GameViewController?
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        let pointsBox = SKSpriteNode(color: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), size: CGSize(width: frame.size.width, height: 200))
        pointsBox.position = CGPoint(x: 0, y: 667)
        pointsBox.physicsBody = SKPhysicsBody(rectangleOf: pointsBox.size)
        pointsBox.physicsBody?.categoryBitMask = Category.pointsBlock
        pointsBox.physicsBody?.collisionBitMask = Category.arrow
        pointsBox.physicsBody?.contactTestBitMask = Category.arrow
        pointsBox.physicsBody?.isDynamic = false
        pointsBox.physicsBody?.affectedByGravity = false
        self.addChild(pointsBox)
        if let someObjectNode = self.childNode(withName: "pointsLabel") as? SKLabelNode {
              someObjectNode.text = "Points: \(String(points))"
             }
           
        start()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let location = t.location(in: self)
            spawnArrow(at: CGPoint(x: location.x, y: -700))
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func start() {
        points = 0
        let action2 = SKAction.run(spawnGameEndBoxes)
        let waitToSpawn = SKAction.wait(forDuration: 0.5)
        let sequence = SKAction.sequence([waitToSpawn, action2])
        let foreverAction = SKAction.repeatForever(sequence)
        self.run(foreverAction)
    }
    func spawnGameEndBoxes() {
        let gameEndBox = SKSpriteNode(color: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), size: CGSize(width: Int.random(in: 50...200), height: 50))
        gameEndBox.position = CGPoint(x: 375, y: 300)
        gameEndBox.physicsBody = SKPhysicsBody(rectangleOf: gameEndBox.size)
        gameEndBox.physicsBody?.categoryBitMask = Category.block
        gameEndBox.physicsBody?.collisionBitMask = Category.arrow
        gameEndBox.physicsBody?.contactTestBitMask = Category.arrow
        gameEndBox.physicsBody?.isDynamic = false
        gameEndBox.physicsBody?.affectedByGravity = false
        if let particles = SKEmitterNode(fileNamed: "Smoke") {
        particles.position = CGPoint(x: gameEndBox.position.x, y: gameEndBox.position.y)
        self.addChild(particles)
        }
        
        self.addChild(gameEndBox)
        let destination = CGPoint(x: -375, y: 300)
        let action = SKAction.move(to: destination, duration: 1)
        let delete = SKAction.removeFromParent()
        let sequence = SKAction.sequence([action, delete])
        let foreverAction = SKAction.repeatForever(sequence)
        gameEndBox.run(foreverAction)
    }
    func spawnArrow(at: CGPoint) {
        
        arrow = SKSpriteNode(imageNamed: "up-arrow")
        arrow.size = CGSize(width: 100, height: 100)
        arrow.position = at
        arrow.physicsBody = SKPhysicsBody(rectangleOf: arrow.size)
        arrow.physicsBody?.categoryBitMask = Category.arrow
        arrow.physicsBody?.collisionBitMask = Category.pointsBlock | Category.block
        arrow.physicsBody?.contactTestBitMask = Category.pointsBlock | Category.block
        arrow.physicsBody?.isDynamic = true
        arrow.physicsBody?.affectedByGravity = false
        self.addChild(arrow)
        let action = SKAction.applyImpulse(CGVector(dx: Int.random(in: -50...50), dy: 3000), duration: 0.5)
        let delete = SKAction.removeFromParent()
        let sequence = SKAction.sequence([action, delete])
        arrow.run(sequence)
    }
    func didBegin(_ contact: SKPhysicsContact) {
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        if body1.categoryBitMask == Category.arrow && body2.categoryBitMask == Category.block {
            subtractLives()
           
            
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            updateResultsToFirebase()
            print("Game over")
           
            
            endGame()
            
          
          
            
        }
        if body1.categoryBitMask == Category.arrow && body2.categoryBitMask == Category.pointsBlock {
            addPoints()
            animateArrowHitOnPointsBlock(position: body2.node!.position)
            body1.node?.removeFromParent()
            print("That's a point")
        }
    }
    func animateArrowHitOnPointsBlock(position: CGPoint) {
        if let particles = SKEmitterNode(fileNamed: "Points") {
            particles.position = position
            let scale = SKAction.scale(by: 1, duration: 0.1)
            let fade = SKAction.fadeOut(withDuration: 0.5)
            let delete = SKAction.removeFromParent()
            let sequence = SKAction.sequence([scale, fade, delete])
            particles.run(sequence)
            addChild(particles)
           }
    }
    func addPoints() {
      points += 1
        if let someObjectNode = self.childNode(withName: "pointsLabel") as? SKLabelNode {
                    someObjectNode.text = "Points: \(String(points))"
                   }
    }
    func animateArrowHitOnBlock(position: CGPoint) {
        if let particles = SKEmitterNode(fileNamed: "GameOver") {
            particles.position = position
            
            let scale = SKAction.scale(by: 1, duration: 0.1)
            let fade = SKAction.fadeOut(withDuration: 0.5)
            let delete = SKAction.removeFromParent()
            let sequence = SKAction.sequence([scale, fade, delete])
            particles.run(sequence)
            addChild(particles)
        }
    }
    func animateBlockOnHit(at: CGPoint) {
        if let particles = SKEmitterNode(fileNamed: "GameOver.sks") {
            particles.position = at
            let scale = SKAction.scale(by: 1, duration: 0.1)
            let fade = SKAction.fadeOut(withDuration: 0.5)
            let delete = SKAction.removeFromParent()
            let sequence = SKAction.sequence([scale, fade, delete])
            particles.run(sequence)
            addChild(particles)
            
        }
    }
    func updateResultsToFirebase() {
        let uid = Auth.auth().currentUser?.uid
               let db = Firestore.firestore()
        let docRef = db.collection("Players").whereField("uid", isEqualTo: uid!)
        docRef.getDocuments { (snapshot, error) in
                  if error != nil {
                      
                  }
                 guard let snap = snapshot?.documents else { return }
                  for doc in snap {
                      let data = doc.data()
                          let highscore = data["HighScore"] as? Int ?? 0
                          
                         
                        if self.points > highscore {
                            self.updateHighScore(withPoints: self.points)
                        }
                     
                    
                     
                  }
                  
                  
          }
    }
    func subtractLives() {
        lives -= 0
    }
    func updateHighScore(withPoints: Int) {
            let db = Firestore.firestore()
                 let uid = Auth.auth().currentUser?.uid
                 let ref = db.collection("Players").document(uid!)

                 
               
               ref.updateData([
                "HighScore": withPoints
               ]) { err in
                   if let err = err {
                       print("Error updating document: \(err)")
                   } else {
                       print("Document successfully updated")
                    
                   }
               }
        }
  
    func endGame() {
        if lives == 0 {

            if let nextScene = GameOverScene(fileNamed: "GameOverScene") {
                                  nextScene.scaleMode = .aspectFill
                              let transition = SKTransition.crossFade(withDuration: 0.5)
                                  self.view?.presentScene(nextScene, transition: transition)
                               
                              }
        }
     
     
        
    }
        
      
       
        
        
    }

