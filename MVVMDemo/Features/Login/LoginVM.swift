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
    case updateLoginButtonEnabled(value: Bool)
    case updateLoginButtonHidden(value: Bool)
    case updateLoadingViewHidden(value: Bool)
    case showAlert(value: String)
    case presentToNextPage
}

class LoginViewModel: BaseViewModel<LoginViewModelInputEvent, LoginViewModelOutputEvent, LoginModelProvidable> {
    
    // Subjects, should be private. These values ​​can only be changed privately.
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
                    self.sendActionEvent(event: .presentToNextPage)
                } catch LoginError.usernameOrPasswordIsWrong {
                    self.sendActionEvent(event: .showAlert(value: "Username or Password is incorrect!"))
                } catch {
                    assertionFailure()
                    self.sendActionEvent(event: .showAlert(value: error.localizedDescription))
                }
                self.showLoadingSubject.value = false
            }
        }
    }
    
    override var stateList: [AnyPublisher<LoginViewModelOutputEvent, Never>] {
        let updateLoginButtonEnabled = usernameSubject.combineLatest(passwordSubject).map { (username, password) in
            // Enable login button only when both username and password are non-empty.
            LoginViewModelOutputEvent.updateLoginButtonEnabled(value: !username.isEmpty && !password.isEmpty)
        }.eraseToAnyPublisher()
        let updateLoginButtonHidden = showLoadingSubject.map { LoginViewModelOutputEvent.updateLoginButtonHidden(value: $0) }.eraseToAnyPublisher()
        let updateLoadingViewHidden = showLoadingSubject.map { LoginViewModelOutputEvent.updateLoadingViewHidden(value: !$0) }.eraseToAnyPublisher()
        return [updateLoginButtonEnabled, updateLoginButtonHidden, updateLoadingViewHidden]
    }
}
