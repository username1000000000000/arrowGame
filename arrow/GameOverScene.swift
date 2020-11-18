//
//  GameOverScene.swift
//  arrow
//
//  Created by david robertson on 11/17/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    override func didMove(to view: SKView) {
        print("Game over")
        let wait = SKAction.wait(forDuration: 2)
        let action = SKAction.run(transition)
        let sequence = SKAction.sequence([wait, action])
        self.run(sequence)
    }
    func transition() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                   let viewController = storyboard.instantiateViewController(withIdentifier :"Navigation")
        viewController.modalPresentationStyle = .fullScreen
                   let currentViewController:UIViewController = UIApplication.shared.keyWindow!.rootViewController!
                   currentViewController.present(viewController, animated: false, completion: nil)
        let vc = GameViewController()
                  vc.dismiss(animated: true, completion: nil)
    }
}
