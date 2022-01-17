//
//  DocumentBrowserViewController.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers
import EPUBKit

enum ERFileType: String {
    case txt = "public.plain-text"
    case rtf = "public.rtf"
    case rtfd = "com.apple.rtfd"
    case pdf = "com.adobe.pdf"
    case epub = "org.idpf.epub-container"
    
    func ext() -> String {
        String(describing: self)
    }
}

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        allowsDocumentCreation = true
        allowsPickingMultipleItems = false
        
        // Update the style of the UIDocumentBrowserViewController
        // browserUserInterfaceStyle = .dark
        // view.tintColor = .white
        
        // Specify the allowed content types of your application via the Info.plist.
        
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIDocumentBrowserViewControllerDelegate
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
        let newDocumentURL: URL? = Bundle.main.url(forResource: "Untitled", withExtension: "rtf")
        
        // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
        // Make sure the importHandler is always called, even if the user cancels the creation request.
        if newDocumentURL != nil {
            importHandler(newDocumentURL, .copy)
        } else {
            importHandler(nil, .none)
        }
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        // Present the Document View Controller for the first document that was picked.
        // If you support picking multiple items, make sure you handle them all.
        presentDocument(at: sourceURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
        // Present the Document View Controller for the new newly created document
        presentDocument(at: destinationURL)
    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
        // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
    }
    
    // MARK: Document Presentation
    
    func presentDocument(at documentURL: URL) {
        let type = UTType(filenameExtension: documentURL.pathExtension) ?? .plainText
        
        let _ = documentURL.startAccessingSecurityScopedResource()
        switch type {
            case .pdf:
                let pdfViewController = PDFViewController.instantiate(withStoryboard: .main)
                pdfViewController.pdfDocument = PDFDocument(url: documentURL)
                pdfViewController.modalPresentationStyle = .fullScreen
                pdfViewController.modalTransitionStyle = .crossDissolve
                present(pdfViewController, animated: true, completion: nil)
                
            case .epub:
                let epubViewController = EPUBViewController.instantiate(withStoryboard: .main)
                epubViewController.epubDocument = EPUBDocument(url: documentURL)
                epubViewController.modalPresentationStyle = .fullScreen
                epubViewController.modalTransitionStyle = .crossDissolve
                present(epubViewController, animated: true, completion: nil)
                
            case .plainText, .rtf, .rtfd:
                fallthrough
                
            default:
                let documentViewController = DocumentViewController.instantiate(withStoryboard: .main)
                documentViewController.document = Document(fileURL: documentURL)
                documentViewController.modalPresentationStyle = .fullScreen
                documentViewController.modalTransitionStyle = .crossDissolve
                present(documentViewController, animated: true, completion: nil)
        }
        documentURL.stopAccessingSecurityScopedResource()
    }
}

