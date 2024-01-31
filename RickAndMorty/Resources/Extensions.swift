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
