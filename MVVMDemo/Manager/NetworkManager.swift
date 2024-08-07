//
//  NetworkManager.swift
//  MVVMDemo
//
//  Created by Wang Ya on 7/8/24.
//

import Foundation

protocol NetworkManagerProvidable {
    func request(url: URL) async throws
}

class NetworkManager: NetworkManagerProvidable {
    
    func request(url: URL) async throws {
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s delay
    }
    
}
