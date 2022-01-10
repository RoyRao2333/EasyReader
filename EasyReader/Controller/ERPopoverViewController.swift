//
//  ERPopoverViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/10.
//

import UIKit

class ERPopoverViewController: UIViewController {
    weak var parentVC: DocumentViewController?
    
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
        parentVC?.textView.increaseFontSize()
    }
    
    @IBAction private func decreaseFontSize(_ sender: UIButton) {
        parentVC?.textView.decreaseFontSize()
    }
    
    @IBAction private func changeLightBackground(_ sender: UIButton) {
        parentVC?.theme = .light
    }
    
    @IBAction private func changeRelaxBackground(_ sender: UIButton) {
        parentVC?.theme = .relax
    }
    
    @IBAction private func changeGrayBackground(_ sender: UIButton) {
        parentVC?.theme = .gray
    }
}
