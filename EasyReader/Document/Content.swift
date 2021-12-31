//
//  Content.swift
//  EasyReader
//
//  Created by roy on 2021/12/31.
//

import UIKit

class Content: NSObject {
    var contentString: NSAttributedString = .init(string: "")
    
    init(content: String, attributes: [NSAttributedString.Key: Any]? = nil) {
        contentString = NSAttributedString(string: content, attributes: attributes)
    }
}


extension Content {
    
    func read(from data: Data, ofType fileType: NSAttributedString.DocumentType) {
        if fileType == .plain {
            contentString = NSAttributedString(
                string: String(data: data, encoding: .utf8) ?? "",
                attributes: [.foregroundColor: UIColor.label]
            )
        } else {
            do {
                contentString = try NSAttributedString(data: data, documentType: .rtf)
            } catch {
                logger.error("Read content failed with error:", context: String(describing: error))
            }
        }
    }
    
    func readRTFD(from url: URL) throws {
        do {
            let attributedStr = try NSAttributedString(
                url: url,
                options: [.documentType: NSAttributedString.DocumentType.rtfd],
                documentAttributes: nil
            )
            contentString = attributedStr
        } catch {
            throw error
        }
    }
    
    func data(ofType fileType: NSAttributedString.DocumentType) -> Data {
        contentString.data(fileType)
    }
}
