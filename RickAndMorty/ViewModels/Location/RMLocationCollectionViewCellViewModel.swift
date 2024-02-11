//
//  RMLocationCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 11.02.24.
//

import Foundation

final class RMLocationCollectionViewCellViewModel: Hashable, Equatable {
    
    public let locationName: String
    public let locationType: String
    public let locationDimension: String
    
    static func == (lhs: RMLocationCollectionViewCellViewModel, rhs: RMLocationCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(locationName)
        hasher.combine(locationType)
        hasher.combine(locationDimension)
    }
    
    init(locationName: String, locationType: String, locationDimension: String) {
        self.locationName = locationName
        self.locationType = locationType
        self.locationDimension = locationDimension
    }
}
