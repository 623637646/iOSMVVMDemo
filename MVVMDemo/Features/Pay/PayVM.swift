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
    private let balanceString = CurrentValueSubject<String, Never>("")
    
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
            calculate(input: value)
        }
    }
    
    override var stateList: [AnyPublisher<PayVMOutputEvent, Never>] {
        [
            emailSubject.map({ .didContactUpdate(email: $0) }).eraseToAnyPublisher(),
            balanceString.map({ .didAmountUpdate(number: $0.isEmpty ? "0" : $0) }).eraseToAnyPublisher(),
        ]
    }
    
    private func calculate(input: KeyboardValue) {
        switch input {
        case .number1:
            self.balanceString.value = self.balanceString.value.appending("1")
        case .number2:
            self.balanceString.value = self.balanceString.value.appending("2")
        case .number3:
            self.balanceString.value = self.balanceString.value.appending("3")
        case .number4:
            self.balanceString.value = self.balanceString.value.appending("4")
        case .number5:
            self.balanceString.value = self.balanceString.value.appending("5")
        case .number6:
            self.balanceString.value = self.balanceString.value.appending("6")
        case .number7:
            self.balanceString.value = self.balanceString.value.appending("7")
        case .number8:
            self.balanceString.value = self.balanceString.value.appending("8")
        case .number9:
            self.balanceString.value = self.balanceString.value.appending("9")
        case .dot:
            if self.balanceString.value.isEmpty {
                self.balanceString.value = self.balanceString.value.appending("0.")
            } else if !self.balanceString.value.contains(".") {
                self.balanceString.value = self.balanceString.value.appending(".")
            }
        case .number0:
            if !self.balanceString.value.isEmpty {
                self.balanceString.value = self.balanceString.value.appending("0")
            }
        case .delete:
            var string = self.balanceString.value
            if string == "0." {
                self.balanceString.value = ""
            } else if !string.isEmpty {
                string.removeLast()
                self.balanceString.value = string
            }
        }
    }
}
