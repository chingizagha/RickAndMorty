//
//  RMLocationListViewViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 11.02.24.
//


import UIKit

protocol RMLocationListViewViewModelDelegate: AnyObject{
    func didLoadInitialLocations()
    func didLoadMoreLocations(with newIndexPaths: [IndexPath])
    func didSelectLocation(_ location: RMLocation)
}

final class RMLocationListViewViewModel: NSObject {
    
    public weak var delegate: RMLocationListViewViewModelDelegate?
    
    private var isLoadMoreLocations = false
    
    private var locations: [RMLocation] = [] {
        didSet{
            for location in locations {
                let viewModel = RMLocationCollectionViewCellViewModel(locationName: location.name, locationType: location.type, locationDimension: location.dimension)
                
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMLocationCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllLocationsResponse.Info? = nil
    
    func fetchLocation() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.locations = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialLocations()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadMoreLocations else {
            return
        }
        isLoadMoreLocations = true
        guard let request = RMRequest(url: url) else {
            isLoadMoreLocations = false
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.locations.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                
                strongSelf.locations.append(contentsOf: moreResults)
                DispatchQueue.main.async{
                    strongSelf.delegate?.didLoadMoreLocations(with: indexPathsToAdd)
                    strongSelf.isLoadMoreLocations = false
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadMoreLocations = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

extension RMLocationListViewViewModel: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    // Footer init
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier, for: indexPath) as? RMFooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMLocationCollectionViewCell.cellIdentifier, for: indexPath) as? RMLocationCollectionViewCell else {
            fatalError("Unsupported")
        }
        
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width-20
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let location = locations[indexPath.row]
        delegate?.didSelectLocation(location)
    }
}

extension RMLocationListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadMoreLocations,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {return}
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120){
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
