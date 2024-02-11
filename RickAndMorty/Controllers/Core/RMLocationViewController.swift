//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Chingiz on 27.01.24.
//

import UIKit

/// Controller to show and search for Locations
final class RMLocationViewController: UIViewController, RMLocationListViewDelegate {
    
    private let locationListView = RMLocationListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Locations"
        
        setUpView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    private func setUpView() {
        view.addSubview(locationListView)
        NSLayoutConstraint.activate([
            locationListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func didTapSearch() {
        
    }
    
    func rmLocationView(_ locationListView: RMLocationListView, didSelectLocation location: RMLocation) {
        let detailVC = RMLocationDetailViewController()
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    



}
