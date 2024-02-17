//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Chingiz on 13.02.24.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject{
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
}

final class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    private let searchInputView = RMSearchInputView()
    
    private let noResultsView = RMNoSearchResultsView()
    
    private let resultView = RMSearchResultView()

    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView, resultView)
        addConstraints()
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setUpHandlers(viewModel: viewModel)
        
        resultView.delegate = self
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel){
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] results in
            DispatchQueue.main.async {
                self?.resultView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultView.isHidden = false
            }
        }
        
        viewModel.registerNoResultHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultView.isHidden = true
            }
            
        }

    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            // Search Input View
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            
            // No Results View
            resultView.leftAnchor.constraint(equalTo: leftAnchor),
            resultView.rightAnchor.constraint(equalTo: rightAnchor),
            resultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Results View
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func presentKeyboard(){
        searchInputView.presentKeyboard()
    }

}

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


extension RMSearchView: RMSearchInputViewDelegate{
   
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

extension RMSearchView: RMSearchResultViewDelegate {
    func rmSearchResultView(_ resultsView: RMSearchResultView, didTapLocationAt index: Int) {
        print()
        guard let locationModel = viewModel.locationSearhResult(at: index) else {return}
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
    
    
}
