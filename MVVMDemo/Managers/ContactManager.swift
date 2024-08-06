//
//  ContactManager.swift
//  MVVMDemo
//
//  Created by Wang Ya on 6/8/24.
//

import Foundation

struct Contact {
    let avatarURL: URL?
    let name: String
    let phoneNumber: String
}

protocol ContactManagerProvidable {
    func contactList() -> [Contact]
}

class ContactManager: ContactManagerProvidable {
    
    func contactList() -> [Contact] {
        [
            Contact(avatarURL: URL(string: "https://gravatar.com/avatar/bf2422ccdb357d2dde810017fa27b778?s=400&d=robohash&r=x")!, name: "Yanni", phoneNumber: "+65 88603333"),
            Contact(avatarURL: URL(string: "https://gravatar.com/avatar/0aa2c5863a28b359350b9bf1b7d28fc8?s=400&d=robohash&r=x")!, name: "XiaoYuan", phoneNumber: "+65 88603333"),
            Contact(avatarURL: URL(string: "https://gravatar.com/avatar/9dabf1da5aa5bee598f57adfee649d3a?s=400&d=robohash&r=x")!, name: "Sam", phoneNumber: "+65 88603333"),
        ]
    }
    
}
