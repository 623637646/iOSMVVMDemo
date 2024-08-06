//
//  PayVM.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation

enum KeyboardButton {
    case button0
    case button1
    case button2
    case button3
    case button4
    case button5
    case button6
    case button7
    case button8
    case button9
    case dot
    case delete
}

enum PayVMInputEvent {
    case qrCodeButtonClicked
    case contactButtonClicked
    case switchButtonClicked
    case payButtonClicked
    case keyboardButtonClicked(value: KeyboardButton)
}

enum PayVMOutputEvent {
    case didContactUpdate(email: String)
    case didUnitUpdate(unit: String)
    case didCurrencyNumberUpdate(number: String)
    case didSublabelUpdate(label: String)
    case goToQRCodePage
}

class PayVM: BaseViewModel<PayVMInputEvent, PayVMOutputEvent, PayModelProvidable> {
    
    init() {
        super.init(model: PayModel())
    }
    
    override func handleInputEvent(_ value: PayVMInputEvent) {
        super.handleInputEvent(value)
        switch value {
        case .qrCodeButtonClicked:
            actionSubject.send(.goToQRCodePage)
        case .contactButtonClicked:
            break
        case .switchButtonClicked:
            break
        case .payButtonClicked:
            break
        case .keyboardButtonClicked(value: let value):
            break
        }
    }
}
