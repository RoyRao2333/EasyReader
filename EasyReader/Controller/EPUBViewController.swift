//
//  EPUBViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/17.
//

import UIKit
import WebKit
import EPUBKit
import SnapKit

class EPUBViewController: UIViewController {
    @IBOutlet private var backBtn: UIButton!
    
    private var pageViewController: UIPageViewController!
    
    var epubDocument: EPUBDocument?
    private var toc: [EPUBTableOfContents] = []
    private var pageVCs: [UIViewController] = []
    private var currentPage = 0 {
        didSet {
            let range = (currentPage - 1) ... (currentPage + 1)
            
            for (index, vc) in pageVCs.enumerated() {
                if range ~= index {
                    vc.loadViewIfNeeded()
                } else {
                    vc.view = nil
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        toc = processToc()
        setup()
    }
}


// MARK: Actions -
extension EPUBViewController {
    
    @IBAction private func return2Toc(_ sender: UIButton) {
        if
            let fileURL = epubDocument?.contentDirectory.appendingPathComponent("nav.xhtml", isDirectory: false),
            let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        {
            
        }
    }
    
    @IBAction private func dismissSelf(_ sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.epubDocument = nil
        }
    }
}


// MARK: Private Methods -
extension EPUBViewController {
    
    private func setup() {
        pageViewController = UIPageViewController(
            transitionStyle: .pageCurl,
            navigationOrientation: .horizontal,
            options: nil
        )
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(backBtn.snp.bottom).offset(15)
        }
        
        toc.forEach {
            if
                let itemPath = $0.item,
                let fileURL = epubDocument?.contentDirectory.appendingPathComponent(itemPath)
            {
                pageVCs.append(createWebVC(for: fileURL))
            }
        }
        
        pageViewController.setViewControllers(
            [pageVCs[0]],
            direction: .forward,
            animated: false
        )
    }
    
    private func createWebVC(for fileURL: URL) -> UIViewController {
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        let preferences = WKWebpagePreferences()
        preferences.allowsContentJavaScript = true
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = preferences
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.loadFileURL(fileURL, allowingReadAccessTo: documentURL ?? fileURL)
        
        let vc = UIViewController()
        vc.view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return vc
    }
    
    private func processToc(_ tocArray: [EPUBTableOfContents]? = nil) -> [EPUBTableOfContents] {
        guard let tocArray = tocArray ?? epubDocument?.tableOfContents.subTable else { return [] }
        
        var result: [EPUBTableOfContents] = []
        tocArray.forEach {
            if let nested = $0.subTable, !nested.isEmpty {
                result.append(contentsOf: processToc(nested))
            } else {
                result.append($0)
            }
        }
        
        return result
    }
}


// MARK: PageViewController Delegate
extension EPUBViewController: UIPageViewControllerDelegate {
    
}


// MARK: PageViewController DataSource
extension EPUBViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pageVCs.firstIndex(of: viewController), index > 0 else { return nil }
//
//        currentPage = index - 1
//
        return pageVCs[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageVCs.firstIndex(of: viewController), index < pageVCs.count - 1 else { return nil }
        
//        currentPage = index + 1
        
        return pageVCs[index + 1]
    }
}


extension EPUBViewController {
    
    private enum PageNav: String, Hashable {
        case prev = "prev"
        case current = "current"
        case next = "next"
    }
}
