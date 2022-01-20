//
//  Defaults.swift
//  EasyReader
//
//  Created by roy on 2022/1/19.
//

import Defaults

extension Defaults.Keys {
    static let storage = Key<[ERFile]>("storageKey", default: [])
}
