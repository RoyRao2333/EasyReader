//
//  URLExtension.swift
//  EasyTextor
//
//  Created by roy on 2021/12/21.
//

import Foundation

// MARK: URL -
extension URL {
    
    /// Return `true` to stop iterating, or `false` to continue.
    func foreachRow(_ mode: String = "r", _ rowParcer: (String, Int) -> Bool) {
        // Here we should use path not the absoluteString (wich contains file://)
        let path = self.path
        
        guard
            let cfilePath = (path as NSString).utf8String,
            let m = (mode as NSString).utf8String
        else { return }
        
        // Open file with specific mode (just use "r")
        guard let file = fopen(cfilePath, m) else {
            logger.warning("fopen can't open file: \"\(path)\", mode: \"\(mode)\"")
            return
        }
        
        // Row capacity for getline()
        var cap = 0
        
        var row_index = 0
        
        // Row container for getline()
        var cline: UnsafeMutablePointer<CChar>? = nil
        
        // Free memory and close file at the end
        defer {
            free(cline)
            fclose(file)
        }
                    
        while getline(&cline, &cap, file) > 0 {
            if
                let crow = cline,
                // The output line may contain '\n' that's why we filtered it
                let s = String(utf8String: crow)?.filter({ ($0.asciiValue ?? 0) >= 32 })
            {
                if rowParcer(s, row_index) {
                    break
                }
            }
            
            row_index += 1
        }
    }
    
    var mimeType: String {
        MimeType(ext: self.pathExtension)
    }
}


// MARK: NSURL
extension NSURL {
    
    var mimeType: String {
        MimeType(ext: self.pathExtension)
    }
}
