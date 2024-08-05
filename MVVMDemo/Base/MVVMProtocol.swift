//
//  MVVMProtocol.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine

/// Protocol for handling input events from external sources.
protocol InputEventHandler {
    associatedtype InputEventType
    // Method to handle input events triggered from outside.
    func handleInputEvent(_ value: InputEventType)
}

/// Protocol for providing a publisher to notify external subscribers about events .
protocol OutputEventObservable {
    associatedtype OutputEventType
    // Publisher for notifying external subscribers about events.
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> { get }
}
