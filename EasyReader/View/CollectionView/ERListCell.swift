//
//  ERListCell.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit

class ERListCell: UICollectionViewListCell {
    var file: ERFile?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfig = ERListContentConfiguration().updated(for: state)
        
        newConfig.file = file
        
        contentConfiguration = newConfig
    }
}
