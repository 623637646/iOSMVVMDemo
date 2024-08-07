//
//  MVVMDemoTests.swift
//  MVVMDemoTests
//
//  Created by Wang Ya on 5/8/24.
//

import XCTest
import Combine
@testable import MVVMDemo

final class MVVMDemoTests: XCTestCase {

    func testLoginViewModel() {
        class FakeLoginModel: LoginModelProvidable {
            let usernameSubject = CurrentValueSubject<String, Never>("")
            
            let passwordSubject = CurrentValueSubject<String, Never>("")
            
            func login() async throws {
                // Fake implementation for testing.
            }
        }
        
        let viewModel = LoginViewModel(model: FakeLoginModel())
        // test viewModel
    }

}
