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

class BaseViewController<ViewType, ViewModelType>: UIViewController where ViewType: ViewProvidable, ViewModelType: ViewModelProvidable {

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
            guard let self else { return }
            self.handleViewModelOutputEvent(event: value)
        }.store(in: &cancellables)
        
        // Bind the state of ViewModel
        viewModel.statePublisher.sink { [weak self] value in
            guard let self, let view = self.contentView else { return }
            self.handleViewModelStateUpdated(state: value, view: view)
        }.store(in: &cancellables)
        
        // Bind the output events of View
        guard let view = self.contentView else {
            assertionFailure()
            return
        }
        view.outputEventPublisher.sink { [weak self] value in
            guard let self else { return }
            self.handleViewOutputEvent(event: value, viewModel: self.viewModel)
        }.store(in: &cancellables)
    }
    
    func createView(frame: CGRect) -> ViewType {
        // Subclass Override
        fatalError("Don't call this method. Subclass have to override this method.")
    }
    
    func handleViewModelOutputEvent(event: ViewModelType.OutputEventType) {
        // Subclass Override
    }
    
    func handleViewModelStateUpdated(state: ViewModelType.StateType, view: ViewType){
        // Subclass Override
    }
    
    func handleViewOutputEvent(event: ViewType.OutputEventType, viewModel: ViewModelType) {
        // Subclass Override
    }
    
}
