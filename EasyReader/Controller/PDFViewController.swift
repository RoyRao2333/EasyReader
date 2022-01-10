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
    
    var pdfDocument: PDFDocument?
    private var pdfView: PDFView!
    
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
        pdfView = PDFView(frame: .zero)
        pdfView.delegate = self
        view.addSubview(pdfView)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.snp.makeConstraints { make in
            make.top.equalTo(backBtn.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview()
            make.bottomMargin.equalTo(view.snp.bottomMargin)
        }
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
