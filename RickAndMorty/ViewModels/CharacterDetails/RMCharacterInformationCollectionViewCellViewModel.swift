//
//  RMCharacterInformationCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Chingiz on 07.02.24.
//

import UIKit


final class RMCharacterInformationCollectionViewCellViewModel {
    
    private let type: `Type`
    private let value: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    public var title: String {
        type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty {return "None"}
        
        if let date = Self.dateFormatter.date(from: value),
            type == .created {
            return Self.shortDateFormatter.string(from: date)
            }
        
        return value
    }
    
    public var iconImage: UIImage?{
        return type.iconImage
    }
    
    public var tintColor: UIColor{
        return type.tintColor
    }
    
    
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var tintColor: UIColor {
            switch self{
            case .status:
                return .systemRed
            case .gender:
                return .systemBlue
            case .type:
                return .systemCyan
            case .species:
                return .systemPink
            case .origin:
                return .systemTeal
            case .created:
                return .systemBrown
            case .location:
                return .systemGreen
            case .episodeCount:
                return .systemIndigo
            }

        }
        
        var iconImage: UIImage? {
            switch self{
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }

        }
        
        var displayTitle: String{
            switch self{
            case 
                    .status,
                    .gender,
                    .origin,
                    .type,
                    .species,
                    .created,
                    .location:
                    return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
                
             
                
            }
        }
    }
    
    init(type: `Type`, value: String) {
        self.value = value
        self.type = type
    }
}