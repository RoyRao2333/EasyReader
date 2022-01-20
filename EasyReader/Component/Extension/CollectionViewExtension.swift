//
//  CollectionViewExtension.swift
//  EasyReader
//
//  Created by roy on 2022/1/20.
//

import UIKit

extension UICollectionView {
    
    func showPlaceholder() {
        let phView = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ERListPlaceholderViewController")
            .view
        
        phView?.frame = CGRect(
            x: 0,
            y: 0,
            width: self.bounds.size.width,
            height: self.bounds.size.height
        )
        
        backgroundView = phView
    }
    
    func removePlaceholder() {
        backgroundView = nil
    }
}
