//
//  Document.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit

class Document: UIDocument {
    var content: NSAttributedString?
    
    override func contents(forType typeName: String) throws -> Any {
        // Encode your document with an instance of NSData or NSFileWrapper
        guard let content = content else {
            logger.warning("Current content is nil.")
            return Data()
        }
        
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: content, requiringSecureCoding: false)
            return archivedData
        } catch {
            return Data()
        }
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
        // Load your document from contents
        guard
            let data = contents as? Data,
            let fileContents = try? NSKeyedUnarchiver.unarchivedObject(ofClass: NSAttributedString.self, from: data)
        else {
            return
        }
        
        content = fileContents
    }
}
