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
        ERListContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self { self }
}
