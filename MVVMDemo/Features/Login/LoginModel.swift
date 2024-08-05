//
//  LoginModel.swift
//  YanniTest
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation

enum LoginError: Error {
    case usernameOrPasswordIsWrong
}

protocol LoginModelProvidable {
    func login(username: String, password: String) async throws
}


class LoginModel: LoginModelProvidable {
    func login(username: String, password: String) async throws {
        // Mock login implementation with a delay.
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
        switch (username, password) {
        case ("111", "222"):
            return
        default:
            throw LoginError.usernameOrPasswordIsWrong
        }
    }
}
