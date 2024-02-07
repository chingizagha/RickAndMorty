//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Chingiz on 06.02.24.
//

import Foundation

final class RMImageLoader{
    
    static let shared = RMImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {}
    
    /// Get image content with URL
    /// - Parameters:
    ///   - url: Source url
    ///   - completions: Callback
    public func downloadImage(_ url: URL, completions: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completions(.success(data as Data))
            return
        }
        
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completions(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completions(.success(data))
        }
        task.resume()
    }
}
