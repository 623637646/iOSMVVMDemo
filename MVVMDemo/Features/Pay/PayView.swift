//
//  PayView.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation
import UIKit
import SnapKit

class KeyboardButton: UIButton {
    let value: KeyboardValue
    init(value: KeyboardValue) {
        self.value = value
        super.init(frame: CGRect.zero)
        switch value {
        case .number1:
            self.setTitle("1", for: .normal)
        case .number2:
            self.setTitle("2", for: .normal)
        case .number3:
            self.setTitle("3", for: .normal)
        case .number4:
            self.setTitle("4", for: .normal)
        case .number5:
            self.setTitle("5", for: .normal)
        case .number6:
            self.setTitle("6", for: .normal)
        case .number7:
            self.setTitle("7", for: .normal)
        case .number8:
            self.setTitle("8", for: .normal)
        case .number9:
            self.setTitle("9", for: .normal)
        case .dot:
            self.setTitle(".", for: .normal)
        case .number0:
            self.setTitle("0", for: .normal)
        case .delete:
            self.setTitle("DEL", for: .normal)
        }
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PayView: BaseView<PayVMOutputEvent, PayVMInputEvent> {
    
    private let contactButton = UIButton()
    private let amountLabel = UILabel()
    private let keyboardArea = UIView()
    private let payButton = UIButton()
    private let keyboardButtons: [KeyboardButton]
    
    override init(frame: CGRect) {
        keyboardButtons = KeyboardValue.allCases.map({ KeyboardButton(value: $0) })
        super.init(frame: frame)
        self.backgroundColor = .black
        setupContactButton()
        setupAmountLabel()
        setupButtonArea()
        setupKeyboardButtons()
        setupPayButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContactButton() {
        self.addSubview(contactButton)
        contactButton.layer.borderWidth = 1
        contactButton.layer.borderColor = UIColor.white.cgColor
        contactButton.addTarget(self, action: #selector(contactButtonClicked), for: .touchUpInside)
        contactButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(72)
        }
    }
    
    private func setupAmountLabel() {
        self.addSubview(amountLabel)
        amountLabel.textColor = .white
        amountLabel.textAlignment = .center
        amountLabel.font = amountLabel.font.withSize(44)
        amountLabel.adjustsFontSizeToFitWidth = true;
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(contactButton.snp.bottom).offset(65)
            make.height.equalTo(106)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupButtonArea() {
        self.addSubview(keyboardArea)
        keyboardArea.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(self.snp.width).multipliedBy(220.2/327.0)
        }
    }
    
    private func setupKeyboardButtons() {
        for (index, button) in keyboardButtons.enumerated() {
            keyboardArea.addSubview(button)
            button.addTarget(self, action: #selector(keyboardButtonClicked), for: .touchUpInside)
            button.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(1.0/3.0)
                make.height.equalToSuperview().multipliedBy(1.0/4.0)
                switch index % 3 {
                case 0:
                    make.left.equalToSuperview()
                case 1:
                    make.centerX.equalToSuperview()
                case 2:
                    make.right.equalToSuperview()
                default:
                    assertionFailure()
                }
                switch index / 3 {
                case 0:
                    make.top.equalToSuperview()
                case 1:
                    make.bottom.equalTo(keyboardArea.snp.centerY)
                case 2:
                    make.top.equalTo(keyboardArea.snp.centerY)
                case 3:
                    make.bottom.equalToSuperview()
                default:
                    assertionFailure()
                }
            }
        }
    }
    
    private func setupPayButton() {
        self.addSubview(payButton)
        payButton.setTitle("Pay", for: .normal)
        payButton.setTitleColor(.black, for: .normal)
        payButton.setTitleColor(.lightGray, for: .disabled)
        payButton.backgroundColor = .white
        payButton.addTarget(self, action: #selector(payButtonClicked), for: .touchUpInside)
        payButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.keyboardArea.snp.top).inset(-16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
    }
    
    @objc private func keyboardButtonClicked(sender: KeyboardButton) {
        sendOutputEvent(event: .keyboardButtonClicked(value: sender.value))
    }
    
    @objc private func contactButtonClicked() {
        sendOutputEvent(event: .contactButtonClicked)
    }
    
    @objc private func payButtonClicked() {
        sendOutputEvent(event: .payButtonClicked)
    }
    
    override func handleInputEvent(_ value: PayVMOutputEvent) {
        switch value {
        case .contactUpdated(email: let email):
            contactButton.setTitle(email, for: .normal)
        case .amountUpdated(number: let number):
            amountLabel.text = number
        case .payButtonIsEnabledUpdated(isEnabled: let isEnabled):
            payButton.isEnabled = isEnabled
        case .navigateToQRCodePage:
            assertionFailure()
        case .navigateToContactListPage:
            assertionFailure()
        case .navigateToPreviewPage:
            assertionFailure()
        }
    }
    
}
