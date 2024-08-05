//
//  MVVMDemoTests.swift
//  MVVMDemoTests
//
//  Created by Wang Ya on 5/8/24.
//

import XCTest
@testable import MVVMDemo

final class MVVMDemoTests: XCTestCase {

    func testLoginViewModel() {
        class FakeLoginModel: LoginModelProvidable {
            func login(username: String, password: String) async throws {
                // Fake implementation for testing.
            }
        }
        
        let viewModel = LoginViewModel()
        viewModel.injectModel(model: FakeLoginModel()) // dependency injection
        // test viewModel
    }

}
