//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Chingiz on 31.01.24.
//

import UIKit
extension UIView{
    func addSubviews(_ views: UIView...){
        views.forEach({
            addSubview($0)
        })
    }
}

extension UIDevice {
    /// Check if current device is phone idiom
    static let isiPhone = UIDevice.current.userInterfaceIdiom == .phone
}
