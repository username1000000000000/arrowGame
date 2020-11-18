//
//  Player.swift
//  arrow
//
//  Created by david robertson on 11/16/20.
//  Copyright © 2020 david robertson. All rights reserved.
//

import Foundation

class Player {
    public var firstName: String
    public var lastName: String
    public var fullName: String {
        return firstName + " " + lastName
    }
    public var highScore: Int = 0
    public var uid: String
    public var email: String
    
    init(firstName: String, lastName: String, uid: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.uid = uid
        self.email = email
    }
}
