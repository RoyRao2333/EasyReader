//
//  ERListContentConfiguration.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit

struct ERListContentConfiguration: UIContentConfiguration, Hashable {
    var file: ERFile?
    
    func makeContentView() -> UIView & UIContentView {
        let contentVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ERListContentViewController")
        let contentView = contentVC.view as! ERListContentView
        contentView.configuration = self
        
        return contentView
    }
    
    func updated(for state: UIConfigurationState) -> Self { self }
}
