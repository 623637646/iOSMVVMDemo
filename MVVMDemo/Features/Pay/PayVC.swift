//
//  PayVC.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation
import UIKit

class PayVC: BaseViewController<PayView, PayVM> {
    
    init() {
        super.init(viewModel: PayVM())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "QR Code", style: .plain, target: self, action: #selector(qrCodeButtonClicked))
    }
    
    @objc func qrCodeButtonClicked() {
        sendInputEventToViewModel(event: .qrCodeButtonClicked)
    }
    
    override func handleViewModelOutputEvent(event: PayVMOutputEvent) {
        switch event {
        case .didContactUpdate(email: let email):
            sendInputEventToView(event: .didContactUpdate(email: email))
        case .didAmountUpdate(number: let number):
            sendInputEventToView(event: .didAmountUpdate(number: number))
        case .navigateToQRCodePage:
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        case .navigateToContactListPage:
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        case .navigateToPreviewPage:
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func handleViewOutputEvent(event: PayVMInputEvent) {
        sendInputEventToViewModel(event: event)
    }
}
