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
    @IBOutlet private var directionBtn: UIButton!
    @IBOutlet private var pdfView: PDFView!
    
    var pdfDocument: PDFDocument?
    private var directionMenu: UIMenu!
    private var directionMenuItems: [UIAction] = []
    
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
        pdfView.backgroundColor = .clear
        pdfView.usePageViewController(true)
        pdfView.autoScales = true
        pdfView.displayDirection = .horizontal
        pdfView.delegate = self
        (pdfView.subviews.first?.subviews.first as? UIScrollView)?.showsHorizontalScrollIndicator = false
        
        directionMenuItems = [
            UIAction(
                title: "Horizontal",
                image: UIImage(systemName: "rectangle.portrait.arrowtriangle.2.outward"),
                identifier: .init("FontMenuSystemItem")
            ) { [weak self] _ in
                self?.pdfView.displayDirection = .horizontal
            },
            UIAction(
                title: "Vertical",
                image: UIImage(systemName: "rectangle.arrowtriangle.2.outward"),
                identifier: .init("FontMenuHelveticaItem")
            ) { [weak self] _ in
                self?.pdfView.displayDirection = .vertical
            },
        ]
        
        directionMenu = UIMenu(
            title: "Scroll Direction",
            identifier: .init("PDFViewControllerDirectionMenu"),
            options: [],
            children: directionMenuItems
        )
        directionBtn.showsMenuAsPrimaryAction = true
        directionBtn.menu = directionMenu
    }
}


// MARK: Actions -
extension PDFViewController {
    
    @IBAction private func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.pdfDocument = nil
        }
    }
}


// MARK: PDFView Delegate
extension PDFViewController: PDFViewDelegate {
    
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        UIApplication.shared.open(url)
    }
}
