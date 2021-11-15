//
//  Constans.swift
//  Flash Chat iOS13
//
//  Created by rawezh on 15.11.21.
//  Copyright © 2021 Angela Yu. All rights reserved.
//

import Foundation

struct Constans {
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let cellIdentifier = "ReuseableCell"
    static let cellNibName = "MessageCell"
    
    
    struct BrandColor {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lightBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
