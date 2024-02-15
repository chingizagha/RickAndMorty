//
//  RMNoSearchResultsView.swift
//  RickAndMorty
//
//  Created by Chingiz on 13.02.24.
//

import UIKit

final class RMNoSearchResultsView: UIView {
    
    private let viewModel = RMNoSearchResultsViewViewModel()
    
    private let iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        iconView.translatesAutoresizingMaskIntoConstraints = false
        return iconView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubviews(iconView, titleLabel)
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addConstraints(){
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 90),
            iconView.heightAnchor.constraint(equalToConstant: 90),
            iconView.topAnchor.constraint(equalTo: topAnchor),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 10),
        ])
    }
    
    private func configure() {
        titleLabel.text = viewModel.title
        iconView.image = viewModel.image
    }
}
