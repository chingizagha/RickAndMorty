//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 31.01.24.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable{
    
    public let characterName: String
    private let characterStatus: RMCharacterStatus
    private let characterImageURL: URL?
    
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageURL)
    }
    
    init(
        characterName: String,
        characterStatus: RMCharacterStatus,
        characterImageURL: URL? ){
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageURL = characterImageURL
    }
    
    public var characterStatusText: String{
        return "Status: \(characterStatus.text)"
    }
    
    public func fetchImage(completions: @escaping (Result<Data, Error>) -> Void) {
        guard let url = characterImageURL else {
            completions(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) {data, _, error in
            guard let data = data, error == nil else {
                completions(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            completions(.success(data))
        }
        task.resume()
    }
}
