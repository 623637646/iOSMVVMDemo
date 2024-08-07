//
//  LoginView.swift
//  MVVMDemo
//
//  Created by Wang Ya on 7/8/24.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    // Subviews. We suggest making the subviews private. Only public the needed API to update subviews.
    let usernameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Username"
        view.borderStyle = .roundedRect
        return view
    }()
    
    let passwordTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Password"
        view.borderStyle = .roundedRect
        return view
    }()
    
    let loginButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Login", for: .normal)
        return view
    }()
    
    let loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let tipsView: UILabel = {
        let view = UILabel()
        view.text = "(Username is 111, password is 222)"
        view.textColor = .lightGray
        view.font = view.font.withSize(12)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(usernameTextField)
        self.addSubview(passwordTextField)
        self.addSubview(loginButton)
        self.addSubview(loadingView)
        self.addSubview(tipsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
}
