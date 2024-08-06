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
    case usernameUpdated(value: String)
    case passwordUpdated(value: String)
    case loginButtonClicked
}

enum LoginViewModelOutputEvent {
    case loginButtonEnabledUpdated(value: Bool)
    case loginButtonHiddenUpdated(value: Bool)
    case loadingViewHiddenUpdated(value: Bool)
    case showAlert(value: String)
    case presentToNextPage
}

class LoginViewModel: BaseViewModel<LoginViewModelInputEvent, LoginViewModelOutputEvent, LoginModelProvidable> {
    
    // State
    
    private var loginButtonEnabledState: AnyPublisher<Bool, Never> {
        return model.usernameSubject.combineLatest(model.passwordSubject).map { (username, password) in
            // Enable login button only when both username and password are non-empty.
            return !username.isEmpty && !password.isEmpty
        }.eraseToAnyPublisher()
    }
    
    private var loginButtonHiddenState: AnyPublisher<Bool, Never> {
        return loadingSubject.eraseToAnyPublisher()
    }
    
    private var loadingViewHiddenState: AnyPublisher<Bool, Never> {
        return loadingSubject.map({ !$0 }).eraseToAnyPublisher()
    }
    
    // Subjects, should be private. These values ​​can only be changed privately.
    
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(model: LoginModel())
    }
    
    override func handleInputEvent(_ value: LoginViewModelInputEvent) {
        switch value {
        case .usernameUpdated(value: let value):
            model.usernameSubject.value = value
        case .passwordUpdated(value: let value):
            model.passwordSubject.value = value
        case .loginButtonClicked:
            self.loadingSubject.value = true
            Task { @MainActor in
                do {
                    try await self.model.login()
                    self.sendActionEvent(event: .presentToNextPage)
                } catch LoginError.usernameOrPasswordIsWrong {
                    self.sendActionEvent(event: .showAlert(value: "Username or Password is incorrect!"))
                } catch {
                    assertionFailure()
                    self.sendActionEvent(event: .showAlert(value: error.localizedDescription))
                }
                self.loadingSubject.value = false
            }
        }
    }
    
    override var stateList: [AnyPublisher<LoginViewModelOutputEvent, Never>] {
        return [
            loginButtonEnabledState.map({
                LoginViewModelOutputEvent.loginButtonEnabledUpdated(value: $0)
            }).eraseToAnyPublisher(),
            loginButtonHiddenState.map({ 
                LoginViewModelOutputEvent.loginButtonHiddenUpdated(value: $0)
            }).eraseToAnyPublisher(),
            loadingViewHiddenState.map({ 
                LoginViewModelOutputEvent.loadingViewHiddenUpdated(value: $0)
            }).eraseToAnyPublisher(),
        ]
    }
}
