//
//  RMEpisodeInformationCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 11.02.24.
//

import Foundation

final class RMEpisodeInformationCollectionViewCellViewModel{
    public let title: String
    public let value: String
    
    init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
