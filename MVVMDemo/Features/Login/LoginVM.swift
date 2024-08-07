//
//  LoginVM.swift
//  YanniTest
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine

class LoginViewModel: BaseViewModel<Void, LoginViewModel.InputFromViewEvent, LoginViewModel.OutputToVCEvent, LoginViewModel.OutputToViewEvent, LoginModelProvidable> {
    
    enum InputFromViewEvent {
        case usernameUpdated(value: String)
        case passwordUpdated(value: String)
        case loginButtonClicked
    }
    
    enum OutputToVCEvent {
        case showAlert(value: String)
        case presentToNextPage
    }
    
    enum OutputToViewEvent {
        case loginButtonEnabledUpdated(value: Bool)
        case loginButtonHiddenUpdated(value: Bool)
        case loadingViewHiddenUpdated(value: Bool)
    }
    
    // Subjects, should be private. These values ​​can only be changed privately.
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        super.init(model: LoginModel())
    }
    
    override func handleInputEventFromView(_ value: InputFromViewEvent) {
        switch value {
        case .usernameUpdated(value: let value):
            model.usernameSubject.value = value
        case .passwordUpdated(value: let value):
            model.passwordSubject.value = value
        case .loginButtonClicked:
            login()
        }
    }
        
    override var stateList: [AnyPublisher<OutputToViewEvent, Never>] {
        let loginButtonEnabledState = model.usernameSubject.combineLatest(model.passwordSubject).map { (username, password) in
            // Enable login button only when both username and password are non-empty.
            return !username.isEmpty && !password.isEmpty
        }.map({
            OutputToViewEvent.loginButtonEnabledUpdated(value: $0)
        }).eraseToAnyPublisher()
        
        let loginButtonHiddenState = loadingSubject.map({
            OutputToViewEvent.loginButtonHiddenUpdated(value: $0)
        }).eraseToAnyPublisher()
        
        let loadingViewHiddenState = loadingSubject.map({ !$0 }).map({
            OutputToViewEvent.loadingViewHiddenUpdated(value: $0)
        }).eraseToAnyPublisher()
        
        return [
            loginButtonEnabledState,
            loginButtonHiddenState,
            loadingViewHiddenState,
        ]
    }
    
    private func login() {
        self.loadingSubject.value = true
        Task { @MainActor in
            do {
                try await self.model.login()
                self.sendEventToViewController(event: .presentToNextPage)
            } catch LoginError.usernameOrPasswordIsWrong {
                self.sendEventToViewController(event: .showAlert(value: "Username or Password is incorrect!"))
            } catch {
                assertionFailure()
                self.sendEventToViewController(event: .showAlert(value: error.localizedDescription))
            }
            self.loadingSubject.value = false
        }
    }
}
