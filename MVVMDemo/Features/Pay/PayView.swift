//
//  PayView.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation

class PayView: BaseView<PayVMOutputEvent, PayVMInputEvent> {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
