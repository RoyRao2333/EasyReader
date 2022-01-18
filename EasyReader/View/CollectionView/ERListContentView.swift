//
//  ERListContentView.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit

class ERListContentView: UIView, UIContentView {
    @IBOutlet private var thumbnailImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var fileTypeLabel: UILabel!
    
    var currentConfiguration: ERListContentConfiguration!
    var configuration: UIContentConfiguration {
        get {
            currentConfiguration
        }
        
        set {
            guard let newConfig = newValue as? ERListContentConfiguration else {
                return
            }
            
            apply(configuration: newConfig)
        }
    }
    
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow != nil {
            apply(configuration: currentConfiguration)
        }
    }
}


extension ERListContentView {
    
    private func apply(configuration: ERListContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        
        currentConfiguration = configuration
        
        thumbnailImageView.image = configuration.file?.thumbnail
        titleLabel.text = configuration.file?.fileName
        fileTypeLabel.text = configuration.file?.fileType.ext()
    }
}
