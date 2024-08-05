//
//  MVVMViewModel.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine

/// Protocol for view models that handle input events, provide output event notifications, and notify about state changes.
protocol ViewModelProvidable: InputEventHandler, OutputEventObservable, StateObservable {}

/// A Base ViewModel
class BaseViewModel<InputEventType, OutputEventType, StateType, ModelTtpe>: ViewModelProvidable {
    
    // It's `var`, because we need to inject the mock depemdency in unit tests.
    internal private(set) var model: ModelTtpe
    
    // It should be internal. These values ​​can only be submited internally.
    internal let outputEventSubject = PassthroughSubject<OutputEventType, Never>()
    
    init(model: ModelTtpe) {
        self.model = model
    }
    
    func injectModel(model: ModelTtpe){
        self.model = model
    }
    
    // MARK: OutputEventObservable
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> {
        outputEventSubject.eraseToAnyPublisher()
    }

    // MARK: InputEventHandler
    func handleInputEvent(_ value: InputEventType) {
        // Subclass Override
    }
    
    // MARK: StateObservable
    var stateList: [AnyPublisher<StateType, Never>] {
        // Subclass Override
        []
    }
}
