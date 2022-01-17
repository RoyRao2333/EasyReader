//
//  FileAccess.swift
//  EasyTextor
//
//  Created by roy on 2021/12/21.
//

import Foundation

protocol FileAccessProtocol {
    func read(from url: URL) throws -> String
    func readAsync(from url: URL, completion: @escaping (Result<String, Error>) -> Void)
    func write(_ string: String, to url: URL) throws
    func writeAsync(_ string: String, to url: URL, completion: @escaping (Result<Void, Error>) -> Void)
}


enum ReadWriteError: LocalizedError {
    case doesNotExist
    case readFailed(Error)
    case canNotCreateFolder
    case canNotCreateFile
    case canNotAccessFile
    case encodingFailed
    case writeFailed(Error)
}


class FileAccess {
    
    static let shared = FileAccess()
    
    private init() {}
    
    // MARK: Properties
    
    let queue: DispatchQueue = .global()
    let fileManager: FileManager = .default
    
    
    // MARK: Private functions
    
    private func doRead(from url: URL) throws -> String {
        var isDir: ObjCBool = false
        guard fileManager.fileExists(atPath: url.path, isDirectory: &isDir) && !isDir.boolValue else {
            throw ReadWriteError.doesNotExist
        }
        
        let string: String
        do {
            string = try String(contentsOf: url)
        } catch {
            throw ReadWriteError.readFailed(error)
        }
        
        return string
    }
    
    private func doWrite(_ string: String, to url: URL) throws {
        let folderURL = url.deletingLastPathComponent()
        
        var isFolderDir: ObjCBool = false
        if fileManager.fileExists(atPath: folderURL.path, isDirectory: &isFolderDir) {
            if !isFolderDir.boolValue {
                throw ReadWriteError.canNotCreateFolder
            }
        } else {
            do {
                try fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                throw ReadWriteError.canNotCreateFolder
            }
        }
        
        var isDir: ObjCBool = false
        guard !fileManager.fileExists(atPath: url.path, isDirectory: &isDir) || !isDir.boolValue else {
            throw ReadWriteError.canNotCreateFile
        }
        
        guard let data = string.data(using: .utf8) else {
            throw ReadWriteError.encodingFailed
        }
        
        do {
            try data.write(to: url)
        } catch {
            throw ReadWriteError.writeFailed(error)
        }
    }
    
}


// MARK: Shared Methods -
extension FileAccess: FileAccessProtocol {
    
    func read(from url: URL) throws -> String {
        try queue.sync { try doRead(from: url) }
    }
    
    func readAsync(from url: URL, completion: @escaping (Result<String, Error>) -> Void) {
        queue.async { [weak self] in
            guard let weakSelf = self else { return }
            
            do {
                let result = try weakSelf.doRead(from: url)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func write(_ string: String, to url: URL) throws {
        try queue.sync { try doWrite(string, to: url) }
    }
    
    func writeAsync(_ string: String, to url: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        queue.async { [weak self] in
            guard let weakSelf = self else { return }
            
            do {
                try weakSelf.doWrite(string, to: url)
                completion(.success(Void()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
