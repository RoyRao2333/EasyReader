//
//  ERListContentView.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit
import SnapKit

class ERListContentView: UIView, UIContentView {
    @IBOutlet private var containerView: UIView!
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
    
    
    init(configuration: ERListContentConfiguration) {
        super.init(frame: .zero)
        
        loadNib()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ERListContentView {
    
    private func loadNib() {
        Bundle.main.loadNibNamed("\(ERListContentView.self)", owner: self, options: nil)
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func apply(configuration: ERListContentConfiguration) {
        guard configuration != currentConfiguration else { return }
        
        currentConfiguration = configuration
        
        if
            let jpegData = configuration.file?.thumbnail,
            let thumbnail = UIImage(data: jpegData)
        {
            thumbnailImageView.image = thumbnail
        }
        titleLabel.text = configuration.file?.fileName
        fileTypeLabel.text = configuration.file?.fileType.ext()
    }
}
