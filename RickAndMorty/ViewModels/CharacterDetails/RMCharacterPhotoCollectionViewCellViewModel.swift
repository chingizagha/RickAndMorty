//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 07.02.24.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    public func fetchImage(completions: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageURL else  {
            completions(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(url, completions: completions)
    }
}
