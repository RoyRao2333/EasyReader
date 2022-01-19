//
//  ERFile.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit
import Defaults

struct ERFile: Hashable, Codable, DefaultsSerializable {
    var thumbnail: Data = Data()
    var fileName: String
    var fileType: ERFileType
    let path: String
}
