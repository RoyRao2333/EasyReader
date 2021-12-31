//
//  DocumentViewController.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Access the document
        document?.open { [weak self] success in
            if success {
                // Display the content of the document, e.g.:
                self?.textView.attributedText = self?.document?.content.contentString
            } else {
                // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
                logger.warning("Open file failed.")
            }
        }
    }
    
    @IBAction func dismissDocumentViewController() {
        dismiss(animated: true) { [weak self] in
            self?.document?.close(completionHandler: nil)
        }
    }
}


extension DocumentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        document?.content.contentString = textView.attributedText
        document?.updateChangeCount(.done)
    }
}
