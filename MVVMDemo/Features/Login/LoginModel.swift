//
//  LoginModel.swift
//  YanniTest
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
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
    
    // TODO: fixme
//    let networkManager: NetworkManagerProvidable
//    
//    init(networkManager: NetworkManagerProvidable) {
//        self.networkManager = networkManager
//    }
    
    func login() async throws {
        // Mock login implementation with a delay.
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
        switch (usernameSubject.value, passwordSubject.value) {
        case ("111", "222"):
            return
        default:
            throw LoginError.usernameOrPasswordIsWrong
        }
    }
}
