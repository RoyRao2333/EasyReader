//
//  FileService.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import Foundation
import Combine

class FileService {
    static let shared = FileService()
    
    let current = CurrentValueSubject<URL?, Never>(nil)
    
    private init() {}
}
