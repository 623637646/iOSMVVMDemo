//
//  LoginVM.swift
//  YanniTest
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine

enum LoginViewModelInputEvent {
    case usernameChanged(value: String)
    case passwordChanged(value: String)
    case loginButtonClicked
}

enum LoginViewModelOutputEvent {
    case showAlert(value: String)
    case presentToNextPage
}

enum LoginViewModelState {
    case isLoginButtonEnabled(value: Bool)
    case isLoading(value: Bool)
}

class LoginViewModel: BaseViewModel<LoginViewModelInputEvent, LoginViewModelOutputEvent, LoginViewModelState, LoginModelProvidable> {
    
    // Subjects, should be private. These values ​​can only be changed internally.
    private let usernameSubject = CurrentValueSubject<String, Never>("")
    private let passwordSubject = CurrentValueSubject<String, Never>("")
    private let showLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(model: LoginModel())
    }
    
    override func handleInputEvent(_ value: LoginViewModelInputEvent) {
        switch value {
        case .usernameChanged(value: let value):
            usernameSubject.value = value
        case .passwordChanged(value: let value):
            passwordSubject.value = value
        case .loginButtonClicked:
            self.showLoadingSubject.value = true
            Task { @MainActor in
                do {
                    try await self.model.login(username: self.usernameSubject.value, password: self.passwordSubject.value)
                    self.outputEventSubject.send(.presentToNextPage)
                } catch LoginError.usernameOrPasswordIsWrong {
                    self.outputEventSubject.send(.showAlert(value: "Username or Password is incorrect!"))
                } catch {
                    assertionFailure()
                    self.outputEventSubject.send(.showAlert(value: error.localizedDescription))
                }
                self.showLoadingSubject.value = false
            }
        }
    }
    
    override var stateList: [AnyPublisher<LoginViewModelState, Never>] {
        let loginButtonIsEnabled = usernameSubject.combineLatest(passwordSubject).map { (username, password) in
            // Enable login button only when both username and password are non-empty.
            LoginViewModelState.isLoginButtonEnabled(value: !username.isEmpty && !password.isEmpty)
        }.eraseToAnyPublisher()
        let showLoading = showLoadingSubject.map { LoginViewModelState.isLoading(value: $0) }.eraseToAnyPublisher()
        return [loginButtonIsEnabled, showLoading]
    }
}
