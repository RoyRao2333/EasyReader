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
    
    var pdfDocument: PDFDocument?
    private var pdfView: PDFView!
    private var thumbnailView: PDFThumbnailView!
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
        pdfView = PDFView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        pdfView.backgroundColor = .clear
        pdfView.usePageViewController(true)
        pdfView.autoScales = true
        pdfView.displayDirection = .horizontal
        pdfView.delegate = self
        (pdfView.subviews.first?.subviews.first as? UIScrollView)?.showsHorizontalScrollIndicator = false
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(15)
        }
        
        thumbnailView = PDFThumbnailView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        thumbnailView.thumbnailSize = CGSize(width: 50, height: 50)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.pdfView = pdfView
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumbnailView)
        thumbnailView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
            make.height.equalTo(70)
            make.top.equalTo(pdfView.snp.bottom)
        }
        
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
