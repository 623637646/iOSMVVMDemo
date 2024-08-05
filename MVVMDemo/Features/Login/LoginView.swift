//
//  LoginView.swift
//  YanniTest
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import UIKit

enum LoginViewInputEvent {
    case loginButtonIsEnabled(value: Bool)
    case loginButtonIsHidden(value: Bool)
    case loadingViewIsHidden(value: Bool)
}

enum LoginViewOutputEvent {
    case usernameChanged(value: String)
    case passwordChanged(value: String)
    case loginButtonClicked
}

class LoginView: BaseView<LoginViewInputEvent, LoginViewOutputEvent> {
    
    // Subviews. We suggest making the subviews private. Only public the needed API to update subviews.
    private let usernameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let loadingView = UIActivityIndicatorView()
    private let tipsView = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // layout, we suggest using autolayout. This demo use frame layout to make it eaiser.
        usernameTextField.frame = CGRect(x: 20, y: 100, width: self.frame.size.width - 40, height: 44)
        passwordTextField.frame = CGRect(x: 20, y: usernameTextField.frame.maxY + 20, width: self.frame.size.width - 40, height: 44)
        loginButton.sizeToFit()
        loginButton.center = CGPoint(x: passwordTextField.center.x, y: passwordTextField.frame.maxY + 20)
        loadingView.center = loginButton.center
        tipsView.frame = CGRect(x: 20, y: loginButton.frame.maxY + 20, width: self.frame.size.width - 40, height: 44)
    }
    
    private func setupSubviews() {
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.addTarget(self, action: #selector(usernameDidChange), for: .editingChanged)
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        
        loginButton.setTitle("Login", for: .normal)
        
        tipsView.text = "(Username is 111, password is 222)"
        tipsView.textColor = .lightGray
        tipsView.font = tipsView.font.withSize(12)
        
        // bind
        loginButton.addTarget(self, action: #selector(loginButtonClickedHandler), for: .touchUpInside)
        
        // add subviews
        self.addSubview(usernameTextField)
        self.addSubview(passwordTextField)
        self.addSubview(loginButton)
        self.addSubview(loadingView)
        self.addSubview(tipsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func loginButtonClickedHandler() {
        outputEventSubject.send(.loginButtonClicked)
    }
    
    @objc private func usernameDidChange(_ textField: UITextField) {
        outputEventSubject.send(.usernameChanged(value: textField.text ?? ""))
    }
    
    @objc private func passwordDidChange(_ textField: UITextField) {
        outputEventSubject.send(.passwordChanged(value: textField.text ?? ""))
    }
    
    override func handleInputEvent(_ value: LoginViewInputEvent) {
        super.handleInputEvent(value)
        // Update UIs
        switch value {
        case .loginButtonIsEnabled(value: let value):
            loginButton.isEnabled = value
        case .loginButtonIsHidden(value: let value):
            loginButton.isHidden = value
        case .loadingViewIsHidden(value: let value):
            loadingView.isHidden = value
            if value {
                loadingView.stopAnimating()
            } else {
                loadingView.startAnimating()
            }
        }
    }
}
