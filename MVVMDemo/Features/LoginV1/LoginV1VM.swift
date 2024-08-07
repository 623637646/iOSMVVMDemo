//
//  LoginV1VM.swift
//  MVVMDemo
//
//  Created by Wang Ya on 7/8/24.
//

import Foundation
import Combine

class LoginV1VM {
    
    let model: LoginModel
    
    // Private subject
    private let loadingSubject = CurrentValueSubject<Bool, Never>(false)
    
    // Public Publishers
    var loginButtonEnabledState: AnyPublisher<Bool, Never> {
        model.usernameSubject.combineLatest(model.passwordSubject).map { (username, password) in
            // Enable login button only when both username and password are non-empty.
            return !username.isEmpty && !password.isEmpty
        }.eraseToAnyPublisher()
    }
    
    var loginButtonHiddenState: AnyPublisher<Bool, Never> {
        loadingSubject.eraseToAnyPublisher()
    }
    
    var loadingViewHiddenState: AnyPublisher<Bool, Never> {
        loadingSubject.map({ !$0 }).eraseToAnyPublisher()
    }
    
    let presentToNextPageSubject = PassthroughSubject<(), Never>()
    
    let showAlertSubject = PassthroughSubject<String, Never>()
    
    init(model: LoginModel) {
        self.model = model
    }
    
    func login() {
        self.loadingSubject.value = true
        Task { @MainActor in
            do {
                try await self.model.login()
                self.presentToNextPageSubject.send(())
            } catch LoginError.usernameOrPasswordIsWrong {
                self.showAlertSubject.send("Username or Password is incorrect!")
            } catch {
                assertionFailure()
                self.showAlertSubject.send(error.localizedDescription)
            }
            self.loadingSubject.value = false
        }
    }
}
