//
//  ERFileType.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import Foundation

enum ERFileType: String {
    case txt = "public.plain-text"
    case rtf = "public.rtf"
    case rtfd = "com.apple.rtfd"
    case pdf = "com.adobe.pdf"
    case epub = "org.idpf.epub-container"
    
    func ext() -> String {
        String(describing: self)
    }
}
