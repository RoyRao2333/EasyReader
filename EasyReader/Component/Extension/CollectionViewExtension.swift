//
//  CollectionViewExtension.swift
//  EasyReader
//
//  Created by roy on 2022/1/20.
//

import UIKit
import SnapKit

extension UIView {
    
    func showPlaceholder() {
        guard subviews.filter({ $0.tag == 1001 }).isEmpty else { return }
        
        guard let phView = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ERListPlaceholderViewController")
            .view
        else { return }
        
        phView.tag = 1001
        addSubview(phView)
        phView.translatesAutoresizingMaskIntoConstraints = false
        phView.snp.makeConstraints { make in
            make.topMargin.equalTo(self.snp.topMargin)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func removePlaceholder() {
        guard let phView = subviews.filter({ $0.tag == 1001 }).first else { return }
        
        phView.removeFromSuperview()
    }
}
