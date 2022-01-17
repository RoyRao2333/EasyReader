//
//  DocumentViewController.swift
//  EasyReader
//
//  Created by roy on 2021/12/30.
//

import UIKit

class DocumentViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet private var backBtn: UIButton!
    @IBOutlet private var fontBtn: UIButton!
    @IBOutlet private var fontSizeBtn: UIButton!

    var document: Document?
    private var fontMenu: UIMenu!
    private var fontMenuItems: [UIAction] = []
    
    var theme: ReaderTheme = .light {
        didSet {
            switch theme {
                case .light:
                    view.backgroundColor = .white
                    textView.textColor = .black
                    backBtn.tintColor = .black
                    fontBtn.tintColor = .black
                    fontSizeBtn.tintColor = .black
                    
                case .gray:
                    view.backgroundColor = .systemGray
                    textView.textColor = .white
                    backBtn.tintColor = .white
                    fontBtn.tintColor = .white
                    fontSizeBtn.tintColor = .white
                    
                case .relax:
                    view.backgroundColor = UIColor(hex: "EAE5D1")
                    textView.textColor = .black
                    backBtn.tintColor = .black
                    fontBtn.tintColor = .black
                    fontSizeBtn.tintColor = .black
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        setup()
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
}


// MARK: Private Methods -
extension DocumentViewController {
    
    private func setup() {
        fontMenuItems = [
            UIAction(title: "System", identifier: .init("FontMenuSystemItem")) { [weak self] _ in
                self?.textView.font = UIFont.systemFont(ofSize: self?.textView.font?.pointSize ?? UIFont.systemFontSize)
            },
            UIAction(title: "Helvetica", identifier: .init("FontMenuHelveticaItem")) { [weak self] _ in
                self?.textView.font = UIFont(name: "HelveticaNeue", size: self?.textView.font?.pointSize ?? UIFont.systemFontSize)
            },
            UIAction(title: "Times New Roman", identifier: .init("FontMenuNewYorkItem")) { [weak self] _ in
                self?.textView.font = UIFont(name: "TimesNewRomanPSMT", size: self?.textView.font?.pointSize ?? UIFont.systemFontSize)
            },
        ]
        
        fontMenu = UIMenu(
            title: "Font",
            identifier: .init("ERFontMenu"),
            options: [],
            children: fontMenuItems
        )
        fontBtn.showsMenuAsPrimaryAction = true
        fontBtn.menu = fontMenu
    }
}


// MARK: Actions -
extension DocumentViewController {
    
    @IBAction private func dismissDocumentViewController() {
        dismiss(animated: true) { [weak self] in
            self?.document?.close(completionHandler: nil)
        }
    }
    
    @IBAction private func showFontSizePopover(_ sender: UIButton) {
        let popVC = PlainPopoverViewController.instantiate(withStoryboard: .main)
        popVC.preferredContentSize = CGSize(width: 180, height: 130)
        popVC.modalPresentationStyle = .popover
        popVC.popoverPresentationController?.permittedArrowDirections = .any
        popVC.popoverPresentationController?.delegate = self
        popVC.popoverPresentationController?.sourceView = sender
        popVC.popoverPresentationController?.sourceRect = sender.bounds
        popVC.parentVC = self
        
        present(popVC, animated: true, completion: nil)
    }
    
    private func changeFont(_ font: UIFont) {
        
    }
}


// MARK: TextView Delegate
extension DocumentViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        document?.content.contentString = textView.attributedText
        document?.updateChangeCount(.done)
    }
}


// MARK: TextView Delegate
extension DocumentViewController: UIPopoverPresentationControllerDelegate {
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}


enum ReaderTheme {
    case light
    case gray
    case relax
}
