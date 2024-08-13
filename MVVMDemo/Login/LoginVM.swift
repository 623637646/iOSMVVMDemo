//
//  LoginVM.swift
//  MVVMDemo
//
//  Created by Wang Ya on 7/8/24.
//

import Foundation
import Combine

protocol LoginVMProvidable {
    var model: LoginModelProvidable { get }
    var presentToNextPageSubject: PassthroughSubject<(), Never> { get }
    var showAlertSubject: PassthroughSubject<String, Never> { get }
    var loadingSubject: CurrentValueSubject<Bool, Never> { get }
    var loginButtonEnabledState: AnyPublisher<Bool, Never> { get }
    func login()
}

class LoginVM: LoginVMProvidable {
    
    let model: LoginModelProvidable
        
    // Public Publishers
    var loginButtonEnabledState: AnyPublisher<Bool, Never> {
        model.usernameSubject.combineLatest(model.passwordSubject).map { (username, password) in
            // Enable login button only when both username and password are non-empty.
            return !username.isEmpty && !password.isEmpty
        }.eraseToAnyPublisher()
    }
    
    let loadingSubject = CurrentValueSubject<Bool, Never>(false)

    let presentToNextPageSubject = PassthroughSubject<(), Never>()
    
    let showAlertSubject = PassthroughSubject<String, Never>()
    
    init(model: LoginModelProvidable) {
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
