//
//  RMEpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 10.02.24.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject{
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel {
    private let endpointURL: URL?
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet{
            createCellViewModels()
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType{
        case information(viewModel: [RMEpisodeInformationCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    public func character(at index: Int) -> RMCharacter?{
        guard let dataTuple = dataTuple else {
            return nil
        }
        
        return dataTuple.characters[index]
    }
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else {return}
        let episode = dataTuple.episode
        let characters = dataTuple.characters
        
        var createdString = episode.created
        if let createdData = RMCharacterInformationCollectionViewCellViewModel.dateFormatter.date(from: episode.created) {
            createdString = RMCharacterInformationCollectionViewCellViewModel.shortDateFormatter.string(from: createdData) 
        }
        
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Episode Name", value: episode.name),
                .init(title: "Air Data", value: episode.air_date),
                .init(title: "Episode", value: episode.episode),
                .init(title: "Created", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status, 
                    characterImageURL: URL(string: character.image))
            }))
        ]
    }
    
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointURL,
        let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) {[weak self] result in
            switch result {
            case .success(let model):
                
                self?.fetchRelatedCharacter(episode: model)
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    private func fetchRelatedCharacter(episode: RMEpisode) {
        let characterURLs: [URL] = episode.characters.compactMap({
            return URL(string: $0)
        })
        let requests: [RMRequest] = characterURLs.compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                defer{
                    group.leave()
                }
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                episode: episode,
                characters: characters
            )
        }
    }
    
}
