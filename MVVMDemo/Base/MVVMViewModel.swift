//
//  MVVMViewModel.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine

/// Protocol for view models that handle input events, provide output event notifications (State notifications + Action notifications)
/// Note: State notifications are different from actions notifications.
/// 1. State notifications are immediately available when observed, similar to CurrentValueSubject.
/// 2. Action notifications are triggered by specific occurrences, similar to PassthroughSubject.
protocol ViewModelProvidable: InputEventHandler, OutputEventObservable {
    
    associatedtype ModelType
    var model: ModelType { get set }
    
    // Publisher for notifying external subscribers about actions.
    var actionPublisher: AnyPublisher<OutputEventType, Never> { get }
    
    // List of publishers for state changes.
    var stateList: [AnyPublisher<OutputEventType, Never>] { get }
}

extension ViewModelProvidable {
    
    mutating func injectModel(model: ModelType){
        self.model = model
    }
    
    // MARK: OutputEventObservable
    // Combined publisher for state and action notifications.
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> {
        Publishers.MergeMany(stateList).merge(with: actionPublisher).eraseToAnyPublisher()
    }
}

/// A Base ViewModel
class BaseViewModel<InputEventType, OutputEventType, ModelType>: ViewModelProvidable {
    
    // It's `var`, because we need to inject the mock depemdency in unit tests.
    var model: ModelType
    
    // It should be internal. These values ​​can only be submited internally.
    private let actionSubject = PassthroughSubject<OutputEventType, Never>()
    
    init(model: ModelType) {
        self.model = model
    }
        
    func sendActionEvent(event: OutputEventType){
        actionSubject.send(event)
    }
    
    // MARK: ViewModelProvidable

    var actionPublisher: AnyPublisher<OutputEventType, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    var stateList: [AnyPublisher<OutputEventType, Never>] {
        // Subclass Override
        []
    }

    // MARK: InputEventHandler
    
    func handleInputEvent(_ value: InputEventType) {
        // Subclass Override
    }
}
