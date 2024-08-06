//
//  MVVMView.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine
import UIKit

/// Protocol for view components that handle input events and provide output event notifications.
protocol ViewProvidable: UIView, InputEventHandler, OutputEventObservable {
}

/// A Base View
class BaseView<InputEventType, OutputEventType>: UIView, ViewProvidable {
    
    // It should be private. These values ​​can only be submited privately.
    private let outputEventSubject = PassthroughSubject<OutputEventType, Never>()
    
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> {
        outputEventSubject.eraseToAnyPublisher()
    }
    
    // MARK: Subclass call
    
    func sendOutputEvent(event: OutputEventType) {
        outputEventSubject.send(event)
    }
    
    // MARK: Subclass override

    func handleInputEvent(_ value: InputEventType) {
        // Subclass override
    }
}
