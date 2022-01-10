//
//  Document.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit

enum ERFileType: String {
    case plain = "public.plain-text"
    case rtf = "public.rtf"
    case rtfd = "com.apple.rtfd"
    case pdf = "com.adobe.pdf"
    
    func ext() -> String {
        String(describing: self)
    }
}

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
                
            case ERFileType.plain.rawValue:
                fallthrough
                
            default:
                return .plain
        }
    }
}
