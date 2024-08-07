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
        let model = LoginModel(networkManager: NetworkManager())
        let viewModel = LoginViewModel(model: model)
        super.init(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleViewModelOutputEvent(event: LoginViewModel.OutputToVCEvent) {
        switch event {
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
    
}
