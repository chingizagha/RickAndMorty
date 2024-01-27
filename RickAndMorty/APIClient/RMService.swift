//
//  RMService.swift
//  RickAndMorty
//
//  Created by Chingiz on 27.01.24.
//

import Foundation

/// Primary  API service object to get Rick and Morty datas
final class RMService {
    
    /// Shared singletion instance
    static let shared = RMService()
    
    /// Privatized constructore
    private init() {}
    
    
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - completion: Callback data or error
    public func execute(_ request: RMRequest, completion: @escaping () -> Void) {
    }
}
