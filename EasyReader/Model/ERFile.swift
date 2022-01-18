//
//  ERFile.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit

struct ERFile: Hashable {
    var thumbnail: UIImage?
    var fileName: String
    var fileType: ERFileType
    let path: String
}
