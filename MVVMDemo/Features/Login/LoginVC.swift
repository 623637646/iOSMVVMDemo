//
//  LoginVC.swift
//  YanniTest
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import UIKit

// TODO: use LoginViewModelProvidable instead of LoginViewModel?
class LoginVC: BaseViewController<LoginView, LoginViewModel> {
    
    init() {
        super.init(viewModel: LoginViewModel())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleViewModelOutputEvent(event: LoginViewModelOutputEvent) {
        switch event {
        case .loginButtonEnabledUpdated(value: let value):
            sendInputEventToView(event: .loginButtonEnabledUpdated(value: value))
        case .loginButtonHiddenUpdated(value: let value):
            sendInputEventToView(event: .loginButtonHiddenUpdated(value: value))
        case .loadingViewHiddenUpdated(value: let value):
            sendInputEventToView(event: .loadingViewHiddenUpdated(value: value))
        case .showAlert(value: let value):
            let alert = UIAlertController(title: "Error", message: value, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        case .presentToNextPage:
            let nextPage = UIViewController()
            nextPage.view.backgroundColor = .white
            let label = UILabel(frame: nextPage.view.frame)
            label.text = "Login success"
            nextPage.view.addSubview(label)
            self.present(nextPage, animated: true)
        }
    }
        
    override func handleViewOutputEvent(event: LoginViewOutputEvent) {
        switch event {
        case .usernameUpdated(value: let value):
            sendInputEventToViewModel(event: .usernameUpdated(value: value))
        case .passwordUpdated(value: let value):
            sendInputEventToViewModel(event: .passwordUpdated(value: value))
        case .loginButtonClicked:
            sendInputEventToViewModel(event: .loginButtonClicked)
        }
    }
    
}
