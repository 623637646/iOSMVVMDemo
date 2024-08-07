//
//  PayVM.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation
import Combine

class PayVM: BaseViewModel<PayVM.InputFromVCEvent, PayVM.InputFromViewEvent, PayVM.OutputToVCEvent, PayVM.OutputToViewEvent, PayModelProvidable> {
    
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
    
    enum InputFromVCEvent {
        case qrCodeButtonClicked
    }
    
    enum InputFromViewEvent {
        case contactButtonClicked
        case payButtonClicked
        case keyboardButtonClicked(value: KeyboardValue)
    }
    
    enum OutputToVCEvent {
        case navigateToQRCodePage
        case navigateToContactListPage
        case navigateToPreviewPage(amount: Decimal)
    }

    enum OutputToViewEvent {
        case contactUpdated(email: String)
        case amountUpdated(number: String)
        case payButtonIsEnabledUpdated(isEnabled: Bool)
    }
    
    private let emailSubject = CurrentValueSubject<String, Never>("ya.wang@okg.com")
    private let amountString = CurrentValueSubject<String, Never>("")
    
    override func handleInputEventFromVC(_ value: InputFromVCEvent) {
        switch value {
        case .qrCodeButtonClicked:
            self.sendEventToViewController(event: .navigateToQRCodePage)
        }
    }
    
    override func handleInputEventFromView(_ value: InputFromViewEvent) {
        switch value {
        case .contactButtonClicked:
            self.sendEventToViewController(event: .navigateToContactListPage)
        case .payButtonClicked:
            guard let availableAmount = Self.getAvailableAmountFromString(string: amountString.value) else { return }
            self.sendEventToViewController(event: .navigateToPreviewPage(amount: availableAmount))
        case .keyboardButtonClicked(value: let value):
            calculate(input: value)
        }
    }
    
    // TODO: Refer to login, fix me 
    override var stateList: [AnyPublisher<OutputToViewEvent, Never>] {
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
