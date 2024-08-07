//
//  LoginModel.swift
//  MVVMDemo
//
//  Created by Wang Ya on 7/8/24.
//

import Foundation
import Combine

enum LoginError: Error {
    case usernameOrPasswordIsWrong
}

protocol LoginModelProvidable {
    var usernameSubject: CurrentValueSubject<String, Never> { get }
    var passwordSubject: CurrentValueSubject<String, Never> { get }
    func login() async throws
}

class LoginModel: LoginModelProvidable {
    
    let usernameSubject = CurrentValueSubject<String, Never>("")
    let passwordSubject = CurrentValueSubject<String, Never>("")
    
    let networkManager: NetworkManagerProvidable
    
    init(networkManager: NetworkManagerProvidable) {
        self.networkManager = networkManager
    }
    
    func login() async throws {
        // Mock login request
        try await networkManager.request(url: URL(string: "www.okx.com")!)
        
        // Mock result
        switch (usernameSubject.value, passwordSubject.value) {
        case ("111", "222"):
            return
        default:
            throw LoginError.usernameOrPasswordIsWrong
        }
    }
}
