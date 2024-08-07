//
//  LoginV1VC.swift
//  MVVMDemo
//
//  Created by Wang Ya on 7/8/24.
//

import Foundation
import UIKit
import Combine

class LoginV1VC: UIViewController {
    
    lazy var viewModel: LoginV1VM = {
        let model = LoginModel(networkManager: NetworkManager())
        return LoginV1VM(model: model)
    }()
    
    // We use weak here, because the system may release the views to save memory. Normally we drag some views of a StoryBoard into viewController, it will be weak. So this is recommend by Apple.
    private weak var contentView: LoginV1View?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func setupView() {
        // Create content view
        assert(self.contentView == nil)
        let view = LoginV1View(frame: self.view.bounds)
        view.usernameTextField.addTarget(self, action: #selector(usernameDidChange), for: .editingChanged)
        view.passwordTextField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        view.loginButton.addTarget(self, action: #selector(loginButtonClickedHandler), for: .touchUpInside)
        self.view.addSubview(view)
        self.contentView = view
    }
    
    private func bind() {
        // Clear existing bindings.
        cancellables.removeAll()
        
        viewModel.presentToNextPageSubject.sink { [weak self] value in
            guard let self else { return }
            let nextPage = UIViewController()
            nextPage.view.backgroundColor = .white
            let label = UILabel(frame: nextPage.view.frame)
            label.text = "Login success"
            nextPage.view.addSubview(label)
            self.present(nextPage, animated: true)
        }.store(in: &cancellables)
        
        viewModel.showAlertSubject.sink { [weak self] value in
            guard let self else { return }
            let alert = UIAlertController(title: "Error", message: value, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self.present(alert, animated: true)
        }.store(in: &cancellables)
        
        viewModel.loadingViewHiddenState.sink { [weak self] value in
            guard let self, let view = self.contentView else { return }
            view.loadingView.isHidden = value
            if value {
                view.loadingView.stopAnimating()
            } else {
                view.loadingView.startAnimating()
            }
        }.store(in: &cancellables)
        
        viewModel.loginButtonEnabledState.sink { [weak self] value in
            guard let self, let view = self.contentView else { return }
            view.loginButton.isEnabled = value
        }.store(in: &cancellables)
        
        viewModel.loginButtonHiddenState.sink { [weak self] value in
            guard let self, let view = self.contentView else { return }
            view.loginButton.isHidden = value
        }.store(in: &cancellables)
    }
    
    @objc private func loginButtonClickedHandler() {
        self.viewModel.login()
    }
    
    @objc private func usernameDidChange(_ textField: UITextField) {
        self.viewModel.model.usernameSubject.value = textField.text ?? ""
    }
    
    @objc private func passwordDidChange(_ textField: UITextField) {
        self.viewModel.model.passwordSubject.value = textField.text ?? ""
    }
    
}
