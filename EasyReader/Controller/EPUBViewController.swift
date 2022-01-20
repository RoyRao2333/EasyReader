//
//  EPUBViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/17.
//

import UIKit
import WebKit
import EPUBKit

class EPUBViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet private var backBtn: UIButton!
    
    var epubDocument: EPUBDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        return2Toc(backBtn)
    }
}


// MARK: Actions -
extension EPUBViewController {
    
    @IBAction private func return2Toc(_ sender: UIButton) {
        if
            let fileURL = epubDocument?.directory.appendingPathComponent("nav.xhtml", isDirectory: false),
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            webView.loadFileURL(fileURL, allowingReadAccessTo: documentURL)
        }
    }
    
    @IBAction private func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.epubDocument = nil
        }
    }
}
