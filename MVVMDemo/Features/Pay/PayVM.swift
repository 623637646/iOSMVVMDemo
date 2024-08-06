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
    case contactUpdated(email: String)
    case amountUpdated(number: String)
    case payButtonIsEnabledUpdated(isEnabled: Bool)
    case navigateToQRCodePage
    case navigateToContactListPage
    case navigateToPreviewPage(amount: Decimal)
}

class PayVM: BaseViewModel<PayVMInputEvent, PayVMOutputEvent, PayModelProvidable> {
    
    private let emailSubject = CurrentValueSubject<String, Never>("ya.wang@okg.com")
    private let amountString = CurrentValueSubject<String, Never>("")
    
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
            guard let availableAmount = Self.getAvailableAmountFromString(string: amountString.value) else { return }
            self.sendActionEvent(event: .navigateToPreviewPage(amount: availableAmount))
        case .keyboardButtonClicked(value: let value):
            calculate(input: value)
        }
    }
    
    override var stateList: [AnyPublisher<PayVMOutputEvent, Never>] {
        [
            emailSubject.map({ .contactUpdated(email: $0) }).eraseToAnyPublisher(),
            amountString.map({ .amountUpdated(number: $0.isEmpty ? "0" : $0) }).eraseToAnyPublisher(),
            amountString.map({ string in
                let availableAmount = Self.getAvailableAmountFromString(string: string)
                return .payButtonIsEnabledUpdated(isEnabled: availableAmount != nil)
            }).eraseToAnyPublisher(),
        ]
    }
    
    private func calculate(input: KeyboardValue) {
        switch input {
        case .number1:
            self.amountString.value = self.amountString.value.appending("1")
        case .number2:
            self.amountString.value = self.amountString.value.appending("2")
        case .number3:
            self.amountString.value = self.amountString.value.appending("3")
        case .number4:
            self.amountString.value = self.amountString.value.appending("4")
        case .number5:
            self.amountString.value = self.amountString.value.appending("5")
        case .number6:
            self.amountString.value = self.amountString.value.appending("6")
        case .number7:
            self.amountString.value = self.amountString.value.appending("7")
        case .number8:
            self.amountString.value = self.amountString.value.appending("8")
        case .number9:
            self.amountString.value = self.amountString.value.appending("9")
        case .dot:
            if self.amountString.value.isEmpty {
                self.amountString.value = self.amountString.value.appending("0.")
            } else if !self.amountString.value.contains(".") {
                self.amountString.value = self.amountString.value.appending(".")
            }
        case .number0:
            if !self.amountString.value.isEmpty {
                self.amountString.value = self.amountString.value.appending("0")
            }
        case .delete:
            var string = self.amountString.value
            if string == "0." {
                self.amountString.value = ""
            } else if !string.isEmpty {
                string.removeLast()
                self.amountString.value = string
            }
        }
    }
    
    private static func getAvailableAmountFromString(string: String) -> Decimal? {
        guard let amount = Decimal(string: string) else { return nil }
        guard string == amount.description else { return nil }
        return amount
    }
}
