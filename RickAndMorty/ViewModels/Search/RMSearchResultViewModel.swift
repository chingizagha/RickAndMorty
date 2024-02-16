//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 16.02.24.
//

import Foundation


enum RMSearchResultViewModel{
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
        
    
}

