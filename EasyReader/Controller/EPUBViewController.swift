//
//  EPUBViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/17.
//

import UIKit
import EPUBKit

class EPUBViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet private var backBtn: UIButton!
    
    var epubDocument: EPUBDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
}


// MARK: Private Methods -
extension EPUBViewController {
    
    private func setup() {
        
    }
}
