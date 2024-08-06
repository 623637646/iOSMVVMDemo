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
    
    override func handleViewModelOutputEvent(event: PayVM.OutputToVCEvent) {
        switch event {
        case .navigateToQRCodePage:
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        case .navigateToContactListPage:
            let vc = UIViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        case .navigateToPreviewPage(let amount):
            let vc = UIAlertController(title: "Review Payment", message: "Amount: \(amount)", preferredStyle: .alert)
            vc.addAction(.init(title: "OK", style: .cancel))
            self.present(vc, animated: true)
        }
    }
    
}
