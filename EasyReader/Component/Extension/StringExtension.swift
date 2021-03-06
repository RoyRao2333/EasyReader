//
//  StringExtension.swift
//
//  Created by Roy Rao on 2020/4/5.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Foundation

// MARK: General -
extension String {
    
    func indexOfRepeatingCharacter(of character: Character, count: Int) -> String.Index? {
        var i = 0
        for index in self.indices {
            if self[index] == character {
                i += 1
                if count == i {
                    return index
                } else {
                    continue
                }
            }
        }
        return nil
    }
    
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }
    
    /// Searches through a string to find valid URLs.
    /// - Returns: An array of found URLs.
    func getURLs() -> [URL] {
        var foundUrls: [URL] = []
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return foundUrls
        }

        let matches = detector.matches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: self.utf16.count)
        )

        for match in matches {
            guard let range = Range(match.range, in: self),
                  let retrievedURL = URL(string: String(self[range])) else { continue }
            foundUrls.append(retrievedURL)
        }

        return foundUrls
    }
    
    func localized(withComment comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
    
    func localized(with values: String...) -> String {
        String(format: self.localized(), arguments: values)
    }
    
    static var systemLanguage: String {
        String(Locale.preferredLanguages[0].prefix(2))
    }
    
    static var appVersion: String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
}


// MARK: For Chinese -
extension String {
    
    /// Check whether String consist of 100% Chinese characters.
    ///
    /// - Returns: true if only Chinese
    func isChinese() -> Bool {
        return Int(self.chinesePercentage()) == 100
    }
    
    /// Number of Chinese characters in String.
    ///
    /// - Returns: Chinese character count
    func chineseCharactersCount() -> Int {
        let stripped = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }.joined()
        
        var chineseCount = 0
        
        for scalar in stripped.unicodeScalars {
            switch scalar.value {
            case 19968...40959: // Common
                chineseCount += 1
            case 13312...19903: // Rare
                chineseCount += 1
            case 131072...173791: // Rare, historic
                chineseCount += 1
            case 173824...177983: // Rare, historic
                chineseCount += 1
            case 177984...178207: // Uncommon
                chineseCount += 1
            case 63744...64255: // Duplicates
                chineseCount += 1
            case 194560...195103: // Unifiable variants
                chineseCount += 1
            case 40870...40883: // Interoperability with HKSCS standard
                chineseCount += 1
            case 40884...40891: // Interoperability with GB 18030 standard
                chineseCount += 1
            case 40892...40898: // Interoperability with commercial implementations
                chineseCount += 1
            case 40899: // Correction of mistaken unification
                chineseCount += 1
            case 40900...40902: // Interoperability with ARIB standard
                chineseCount += 1
            case 40903...40907: // Interoperability with HKSCS standard
                chineseCount += 1
            default:
                continue
            }
        }
        
        return chineseCount
    }
    
    /// Percentage of Chinese characters in String.
    ///
    /// - Returns: Chinese characters percentage
    func chinesePercentage() -> Float {
        let chineseCount = self.chineseCharactersCount()
        let stripped = self.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }.joined()
        
        return (Float(chineseCount) / Float(stripped.count)) * 100
    }
}


// MARK: For Emoji -
extension Character {
    
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }

    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }

    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension String {
    var isSingleEmoji: Bool { count == 1 && containsEmoji }

    var containsEmoji: Bool { contains { $0.isEmoji } }

    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }

    var emojiString: String { emojis.map { String($0) }.reduce("", +) }

    var emojis: [Character] { filter { $0.isEmoji } }

    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
}


// MARK: MIME Types -
extension String {
    
    var mimeType: String {
        (self as NSString).mimeType
    }
}

extension NSString {
    
    var mimeType: String {
        MimeType(ext: self.pathExtension)
    }
}


// MARK: String Encoding -
extension String.Encoding {
    static let GB_18030_2000 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GB_18030_2000.rawValue)))
    
    static let GBK_95 = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.GBK_95.rawValue)))
}


// MARK: Attributed String
extension NSAttributedString {

    convenience init(data: Data, documentType: DocumentType, encoding: String.Encoding = .utf8) throws {
        try self.init(attributedString: .init(data: data, options: [.documentType: documentType, .characterEncoding: encoding.rawValue], documentAttributes: nil))
    }

    func data(_ documentType: DocumentType) -> Data {
        // Discussion
        // Raises an rangeException if any part of range lies beyond the end of the receiver’s characters.
        // Therefore passing a valid range allow us to force unwrap the result
        try! data(from: NSMakeRange(0, length), documentAttributes: [.documentType: documentType])
    }

    var text: Data { data(.plain) }
    var html: Data { data(.html)  }
    var rtf:  Data { data(.rtf)   }
    var rtfd: Data { data(.rtfd)  }
}
