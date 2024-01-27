//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Chingiz on 27.01.24.
//

import Foundation

/// Represents uniques API endpoint
@frozen enum RMEndpoint: String{
    
    /// Endpoint to get  Character info
    case character
    /// Endpoint to get Episode info
    case episode
    /// Endpoint to get Location info
    case location
}
