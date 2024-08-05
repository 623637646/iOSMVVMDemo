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

/// Protocol for providing a publisher to notify external subscribers about events.
protocol OutputEventObservable {
    associatedtype OutputEventType
    // Publisher for notifying external subscribers about events.
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> { get }
}

/// Protocol for providing a publisher to notify external subscribers about state changes.
/// Note: State notifications are different from event notifications.
/// 1. State notifications are immediately available when observed, similar to CurrentValueSubject.
/// 2. Event notifications are triggered by specific occurrences, similar to PassthroughSubject.
protocol StateObservable {
    associatedtype StateType
    // List of publishers for state changes.
    var stateList: [AnyPublisher<StateType, Never>] { get }
}

extension StateObservable {
    // Combined publisher for state changes.
    var statePublisher: AnyPublisher<StateType, Never> {
        Publishers.MergeMany(stateList).eraseToAnyPublisher()
    }
}
