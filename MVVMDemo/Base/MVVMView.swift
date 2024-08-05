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
protocol ViewProvidable: UIView, InputEventHandler, OutputEventObservable {}

/// A Base View
class BaseView<InputEventType, OutputEventType>: UIView, ViewProvidable {
    
    // It should be internal. These values ​​can only be submited internally.
    let outputEventSubject = PassthroughSubject<OutputEventType, Never>()
    
    // MARK: OutputEventObservable
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> {
        outputEventSubject.eraseToAnyPublisher()
    }
    
    // MARK: InputEventHandler
    func handleInputEvent(_ value: InputEventType) {
        // Subclass Override
    }
}
