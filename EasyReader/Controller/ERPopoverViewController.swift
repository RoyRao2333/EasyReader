//
//  ERPopoverViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/10.
//

import UIKit

class ERPopoverViewController: UIViewController {
    weak var textView: UITextView?
    weak var contentView: UIView?
    
    @IBOutlet private var largerFontBtn: UIButton!
    @IBOutlet private var smallerFontBtn: UIButton!
    @IBOutlet private var lightBgBtn: UIButton!
    @IBOutlet private var relaxBgBtn: UIButton!
    @IBOutlet private var darkBgBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
}


// MARK: Private Methods -
extension ERPopoverViewController {
    
    private func setup() {
        
    }
}


// MARK: Actions -
extension ERPopoverViewController {
    
    @IBAction private func increaseFontSize(_ sender: UIButton) {
        textView?.increaseFontSize()
    }
    
    @IBAction private func decreaseFontSize(_ sender: UIButton) {
        textView?.decreaseFontSize()
    }
    
    @IBAction private func changeLightBackground(_ sender: UIButton) {
        contentView?.backgroundColor = .white
        textView?.textColor = .black
    }
    
    @IBAction private func changeGrayBackground(_ sender: UIButton) {
        contentView?.backgroundColor = .darkGray
        textView?.textColor = .white
    }
    
    @IBAction private func changeRelaxBackground(_ sender: UIButton) {
        contentView?.backgroundColor = UIColor(hex: "EAE5D1")
        textView?.textColor = .black
    }
}
