//
//  ERFileType.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import Defaults

enum ERFileType: Hashable, Codable {
    case txt
    case rtf
    case rtfd
    case pdf
    case epub
    case other(String)
    
    func ext() -> String {
        switch self {
            case .txt:
                return "txt"
                
            case .rtf:
                return "rtf"
                
            case .rtfd:
                return "rtfd"
                
            case .pdf:
                return "pdf"
                
            case .epub:
                return "epub"
                
            case .other(let ext):
                return ext
        }
    }
    
    func id() -> String {
        switch self {
            case .txt:
                return "public.plain-text"
                
            case .rtf:
                return "public.rtf"
                
            case .rtfd:
                return "com.apple.rtfd"
                
            case .pdf:
                return "com.adobe.pdf"
                
            case .epub:
                return "org.idpf.epub-container"
                
            case .other(_):
                return ""
        }
    }
    
    func fileType() -> String {
        switch self {
            case .txt:
                return "Plain Text"
                
            case .rtf:
                return "Rich Text Format"
                
            case .rtfd:
                return "Rich Text Format Directory"
                
            case .pdf:
                return "Portable Document Format"
                
            case .epub:
                return "Electronic Publication"
                
            case .other(let ext):
                return "." + ext + " File"
        }
    }
}
