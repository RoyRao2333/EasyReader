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


extension FileService {
    
    func saveFile(_ sourceURL: URL) -> ERFile? {
        let _ = sourceURL.startAccessingSecurityScopedResource()
        
        var result: ERFile?
        let title = (sourceURL.path.components(separatedBy: "/").last as NSString?)?.deletingPathExtension ?? "Untitled"
        var fileType: ERFileType
        
        switch sourceURL.pathExtension {
            case ERFileType.txt.ext():
                fileType = .txt
                
            case ERFileType.rtf.ext():
                fileType = .rtf
                
            case ERFileType.rtfd.ext():
                fileType = .rtfd
                
            case ERFileType.pdf.ext():
                fileType = .pdf
                
            case ERFileType.epub.ext():
                fileType = .epub
                
            default:
                fileType = .other((sourceURL.path as NSString).pathExtension)
        }
        
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destURL = documentURL
            .appendingPathComponent(title)
            .appendingPathExtension(fileType.ext())
        
        do {
            try FileManager.default.copyItem(at: sourceURL, to: destURL)
            result = ERFile(fileName: title, fileType: fileType, path: destURL.path)
        } catch {
            logger.error("Save file to document directory failed with error:", context: error)
        }
        
        sourceURL.stopAccessingSecurityScopedResource()
        
        return result
    }
}
