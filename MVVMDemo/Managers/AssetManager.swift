//
//  AssetManager.swift
//  MVVMDemo
//
//  Created by Wang Ya on 6/8/24.
//

import Foundation


protocol AssetManagerProvidable {
    func currentAsset() -> Decimal
}

class AssetManager: AssetManagerProvidable {
    
    func currentAsset() -> Decimal {
        100
    }
    
}
