//
//  MVVMViewModel.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine

enum ViewModelOutputEvent<OutputToVCEventType, OutputToViewEventType> {
    case toViewController(value: OutputToVCEventType)
    case toView(value: OutputToViewEventType)
}

enum ViewModelInputEvent<InputFromVCEventType, InputFromViewEventType> {
    case fromViewController(value: InputFromVCEventType)
    case fromView(value: InputFromViewEventType)
}

/// Protocol for view models that handle input events, provide output event notifications (State notifications + Action notifications)
/// Note: State notifications are different from actions notifications.
/// 1. State notifications are immediately available when observed, similar to CurrentValueSubject. It will send to the View.
/// 2. Action notifications are triggered by specific occurrences, similar to PassthroughSubject. It will send to the ViewController.
protocol ViewModelProvidable: InputEventHandler, OutputEventObservable
where OutputEventType == ViewModelOutputEvent<OutputToVCEventType, OutputToViewEventType>,
      InputEventType == ViewModelInputEvent<InputFromVCEventType, InputFromViewEventType>
{
    associatedtype InputFromVCEventType
    associatedtype InputFromViewEventType
    associatedtype OutputToVCEventType
    associatedtype OutputToViewEventType
        
    // Publisher for notifying external subscribers about actions. Normally it will be send to the ViewController.
    var actionPublisher: AnyPublisher<OutputToVCEventType, Never> { get }
    
    // List of publishers for state changes. Normally it will be send to the View.
    var stateList: [AnyPublisher<OutputToViewEventType, Never>] { get }
    
    func handleInputEventFromVC(_ value: InputFromVCEventType)
    
    func handleInputEventFromView(_ value: InputFromViewEventType)
}

extension ViewModelProvidable {
    
    // Combined publisher for state and action notifications.
    var outputEventPublisher: AnyPublisher<OutputEventType, Never> {
        let state = Publishers.MergeMany(stateList).map({
            ViewModelOutputEvent<OutputToVCEventType, OutputToViewEventType>.toView(value: $0)
        })
        let action = actionPublisher.map({
            ViewModelOutputEvent<OutputToVCEventType, OutputToViewEventType>.toViewController(value: $0)
        })
        return state.merge(with: action).eraseToAnyPublisher()
    }
    
    func handleInputEvent(_ value: InputEventType) {
        switch value {
        case .fromViewController(value: let value):
            handleInputEventFromVC(value)
        case .fromView(value: let value):
            handleInputEventFromView(value)
        }
    }
}

/// A Base ViewModel
class BaseViewModel<InputFromVCEventType, InputFromViewEventType, OutputToVCEventType, OutputToViewEventType, ModelType>: ViewModelProvidable {
    
    let model: ModelType
    
    private let actionSubject = PassthroughSubject<OutputToVCEventType, Never>()
    
    var actionPublisher: AnyPublisher<OutputToVCEventType, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    init(model: ModelType) {
        self.model = model
    }
    
    // MARK: Subclass call
    
    func sendEventToViewController(event: OutputToVCEventType) {
        actionSubject.send(event)
    }
    
    // MARK: Subclass override
    
    var stateList: [AnyPublisher<OutputToViewEventType, Never>] {
        []
    }
    
    func handleInputEventFromVC(_ value: InputFromVCEventType) {
        
    }
    
    func handleInputEventFromView(_ value: InputFromViewEventType) {
        
    }
}
