//
//  RMCharacterInformationCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Chingiz on 07.02.24.
//

import UIKit

final class RMCharacterInformationCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterInformationCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstaints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(viewModel: RMCharacterInformationCollectionViewCellViewModel){
        
    }
}
