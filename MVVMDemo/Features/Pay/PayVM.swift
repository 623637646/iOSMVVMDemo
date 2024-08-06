//
//  PayVM.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation
import Combine

enum KeyboardValue: CaseIterable {
    case number1
    case number2
    case number3
    case number4
    case number5
    case number6
    case number7
    case number8
    case number9
    case dot
    case number0
    case delete
}

enum PayVMInputEvent {
    case qrCodeButtonClicked
    case contactButtonClicked
    case payButtonClicked
    case keyboardButtonClicked(value: KeyboardValue)
}

enum PayVMOutputEvent {
    case didContactUpdate(email: String)
    case didAmountUpdate(number: String)
    case navigateToQRCodePage
    case navigateToContactListPage
    case navigateToPreviewPage
}

class PayVM: BaseViewModel<PayVMInputEvent, PayVMOutputEvent, PayModelProvidable> {
    
    private let emailSubject = CurrentValueSubject<String, Never>("ya.wang@okg.com")
    private let balance = CurrentValueSubject<Double, Never>(0)
    
    init() {
        super.init(model: PayModel())
    }
    
    override func handleInputEvent(_ value: PayVMInputEvent) {
        super.handleInputEvent(value)
        switch value {
        case .qrCodeButtonClicked:
            self.sendActionEvent(event: .navigateToQRCodePage)
        case .contactButtonClicked:
            self.sendActionEvent(event: .navigateToContactListPage)
        case .payButtonClicked:
            self.sendActionEvent(event: .navigateToPreviewPage)
        case .keyboardButtonClicked(value: let value):
            switch value {
            case .number1:
                self.balance.value = self.balance.value * 10 + 1
            case .number2:
                self.balance.value = self.balance.value * 10 + 2
            case .number3:
                self.balance.value = self.balance.value * 10 + 3
            case .number4:
                self.balance.value = self.balance.value * 10 + 4
            case .number5:
                self.balance.value = self.balance.value * 10 + 5
            case .number6:
                self.balance.value = self.balance.value * 10 + 6
            case .number7:
                self.balance.value = self.balance.value * 10 + 7
            case .number8:
                self.balance.value = self.balance.value * 10 + 8
            case .number9:
                self.balance.value = self.balance.value * 10 + 9
            case .dot:
                break
            case .number0:
                self.balance.value = self.balance.value * 10 + 0
            case .delete:
                break
            }
        }
    }
    
    override var stateList: [AnyPublisher<PayVMOutputEvent, Never>] {
        [
            emailSubject.map({ .didContactUpdate(email: $0) }).eraseToAnyPublisher(),
            balance.map({ .didAmountUpdate(number: String(format: "%.f", $0)) }).eraseToAnyPublisher(),
        ]
    }
}
