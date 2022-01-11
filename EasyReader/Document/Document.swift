//
//  Document.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit

class Document: UIDocument {
    var content: Content = Content(content: "")
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        return content.data(ofType: contentType(for: typeName))
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        let typeName = typeName ?? ""
        
        if let data = contents as? Data {
            content.read(from: data, ofType: contentType(for: typeName))
        } else {
            do {
                try content.readRTFD(from: fileURL)
            } catch {
                logger.warning("Load file data failed.")
            }
        }
    }
}


// MARK: Private Methods -
extension Document {
    
    private func contentType(for typeName: String) -> NSAttributedString.DocumentType {
        switch typeName {
            case ERFileType.rtf.rawValue:
                return .rtf
                
            case ERFileType.rtfd.rawValue:
                return .rtfd
                
            case ERFileType.txt.rawValue:
                fallthrough
                
            default:
                return .plain
        }
    }
}
