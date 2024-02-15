//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Chingiz on 11.02.24.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    /// Configuration of search session
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var title: String{
                switch self{
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episodes"
                case .location:
                    return "Search Locations"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config){
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title
        view.backgroundColor = .systemBackground
    }
    


}
