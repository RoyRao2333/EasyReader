//
//  AppDelegate.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit
import QuickLookThumbnailing
import SwiftyBeaver
import Defaults

let logger = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var utilQueue = DispatchQueue.global(qos: .utility)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupLogger()
        reloadPathsForItems()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func application(_ app: UIApplication, open inputURL: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // Ensure the URL is a file URL
        guard
            inputURL.isFileURL,
            var file = FileService.shared.saveFile(inputURL)
        else { return false }
        
        thumbnail(for: inputURL) { thumbnail in
            if let thumbnail = thumbnail, let jpegData = thumbnail.jpegData(compressionQuality: 100) {
                guard let cacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return }
                
                do {
                    let destURL = cacheURL.appendingPathComponent("\(file.fileName)_thumbnail", isDirectory: false)
                    try jpegData.write(to: destURL, options: [.atomic])
                    file.thumbnailPath = destURL.path
                } catch {
                    logger.warning("Save thumbnail failed with error:", context: error)
                }
            }
            
            if !Defaults[.storage].contains(where: { $0.path == file.path }) {
                Defaults[.storage].append(file)
            }
        }

        return true
    }
}


// MARK: Custom Methods -
extension AppDelegate {
    
    private func setupLogger() {
        let console = ConsoleDestination()
        console.format = "$DHH:mm:ss$d $C$L$c: $M $X"
        
        logger.addDestination(console)
    }
    
    private func reloadPathsForItems() {
        guard
            !Defaults[.storage].isEmpty,
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else { return }
        
        Defaults[.storage].indices.forEach {
            let file = Defaults[.storage][$0]
            let newURL = documentURL.appendingPathComponent("\(file.fileName).\(file.fileType.ext())", isDirectory: false)
            Defaults[.storage][$0].path = newURL.path
        }
    }
    
    private func thumbnail(for url: URL, _ completion: @escaping (UIImage?) -> Void) {
        let _ = url.startAccessingSecurityScopedResource()
        
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: CGSize(width: 50, height: 50),
            scale: 1,
            representationTypes: .lowQualityThumbnail
        )
        
        QLThumbnailGenerator.shared.generateRepresentations(for: request) { thumbnail, _, _ in
            completion(thumbnail?.uiImage)
            
            url.stopAccessingSecurityScopedResource()
        }
    }
}
