//
//  MVVMViewController.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//  Copyright © 2024 Shopee. All rights reserved.
//

import Foundation
import Combine
import UIKit

class BaseViewController<ViewType, ViewModelType>: UIViewController
where ViewType: ViewProvidable,
      ViewModelType: ViewModelProvidable,
      ViewType.InputEventType == ViewModelType.OutputToViewEventType,
      ViewType.OutputEventType == ViewModelType.InputFromViewEventType
{
    
    private let viewModel: ViewModelType
    
    // We use weak here, because the system may release the views to save memory. Normally we drag some views of a StoryBoard into viewController, it will be weak. So this is recommend by Apple.
    private weak var contentView: ViewType?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bind()
    }
    
    private func setupView() {
        // Create content view
        assert(self.contentView == nil)
        let view = createView(frame: self.view.bounds)
        self.view.addSubview(view)
        self.contentView = view
    }
    
    private func bind() {
        // Clear existing bindings.
        cancellables.removeAll()
        
        // Bind the output events of ViewModel
        viewModel.outputEventPublisher.sink { [weak self] value in
            assert(Thread.isMainThread)
            guard let self else { return }
            switch value {
            case .toViewController(value: let value):
                self.handleViewModelOutputEvent(event: value)
            case .toView(value: let value):
                guard let view = self.contentView else {
                    assertionFailure()
                    return
                }
                view.handleInputEvent(value)
            }
        }.store(in: &cancellables)
        
        // Bind the output events of View
        guard let view = self.contentView else {
            assertionFailure()
            return
        }
        view.outputEventPublisher.sink { [weak self] value in
            assert(Thread.isMainThread)
            guard let self else { return }
            self.viewModel.handleInputEventFromView(value)
        }.store(in: &cancellables)
    }
    
    private func createView(frame: CGRect) -> ViewType {
        // Subclass override
        return ViewType.init(frame: frame)
    }
    
    // MARK: Subclass call
    
    func sendInputEventToViewModel(event: ViewModelType.InputFromVCEventType) {
        assert(Thread.isMainThread)
        viewModel.handleInputEventFromVC(event)
    }
    
    // MARK: Subclass override
    
    func handleViewModelOutputEvent(event: ViewModelType.OutputToVCEventType) {
        
    }
    
}
