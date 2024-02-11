//
//  RMLocationListView.swift
//  RickAndMorty
//
//  Created by Chingiz on 11.02.24.
//

import UIKit

protocol RMLocationListViewDelegate: AnyObject{
    func rmLocationView(
        _ locationListView: RMLocationListView,
        didSelectLocation location: RMLocation
    )
}

final class RMLocationListView: UIView {
    
    public weak var delegate: RMLocationListViewDelegate?

    private let viewModel = RMLocationListViewViewModel()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let collectinView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(RMLocationCollectionViewCell.self, forCellWithReuseIdentifier: RMLocationCollectionViewCell.cellIdentifier)
        
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(collectinView, spinner)
        addConstraints()
        
        spinner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchLocation()
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectinView.topAnchor.constraint(equalTo: topAnchor),
            collectinView.rightAnchor.constraint(equalTo: rightAnchor),
            collectinView.leftAnchor.constraint(equalTo: leftAnchor),
            collectinView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setUpCollectionView() {
        collectinView.dataSource = viewModel
        collectinView.delegate = viewModel
    }
}

extension RMLocationListView: RMLocationListViewViewModelDelegate{
    
    func didLoadInitialLocations() {
        self.spinner.stopAnimating()
        self.collectinView.isHidden = false
        collectinView.reloadData()
        UIView.animate(withDuration: 0.3) {
            self.collectinView.alpha = 1
        }
    }
    
    func didLoadMoreLocations(with newIndexPaths: [IndexPath]) {
        collectinView.performBatchUpdates {
            self.collectinView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectLocation(_ location: RMLocation) {
        delegate?.rmLocationView(self, didSelectLocation: location)
    }
    
    
}
