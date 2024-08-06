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
    
    override func handleViewModelOutputEvent(event: PayVMOutputEvent, view: PayView) {
        switch event {
        case .didContactUpdate(email: let email):
            break
        case .didUnitUpdate(unit: let unit):
            break
        case .didCurrencyNumberUpdate(number: let number):
            break
        case .didSublabelUpdate(label: let label):
            break
        case .goToQRCodePage:
            let qrCodePage = UIViewController()
            qrCodePage.view.backgroundColor = .white
            self.navigationController?.pushViewController(qrCodePage, animated: true)
        }
    }
    
    override func handleViewOutputEvent(event: PayVMInputEvent, viewModel: PayVM) {
        
    }
}
