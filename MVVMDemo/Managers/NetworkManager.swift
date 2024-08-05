//
//  NetworkManager.swift
//  MVVMDemo
//
//  Created by Wang Ya on 5/8/24.
//

import Foundation

protocol NetworkManagerProvidable {
    func request(url: URL) async throws
}

class NetworkManager: NetworkManagerProvidable {
    
    func request(url: URL) async throws {
        
    }
    
}
