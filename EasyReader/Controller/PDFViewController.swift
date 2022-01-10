//
//  PDFViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/10.
//

import UIKit
import PDFKit
import SnapKit

class PDFViewController: UIViewController {
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var pdfView: PDFView!
    
    var pdfDocument: PDFDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pdfDocument = pdfDocument {
            pdfView.document = pdfDocument
        }
    }
}


// MARK: Private Methods -
extension PDFViewController {
    
    private func setup() {
        pdfView.delegate = self
    }
}


// MARK: Actions -
extension PDFViewController {
    
    @IBAction private func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: PDFView Delegate
extension PDFViewController: PDFViewDelegate {
    
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        UIApplication.shared.open(url)
    }
}
