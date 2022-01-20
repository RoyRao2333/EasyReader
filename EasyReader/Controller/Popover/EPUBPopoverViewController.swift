//
//  EPUBPopoverViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/20.
//

import UIKit
import EPUBKit

class EPUBPopoverViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    
    weak var parentVC: EPUBViewController?
    private lazy var dataSource = makeDataSource()
    private var models: [ERTocItem] = [] {
        didSet {
            applySnapshot()
        }
    }
    
    typealias DataSource = UITableViewDiffableDataSource<Section, ERTocItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ERTocItem>

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadToc()
    }
}


// MARK: Private Methods -
extension EPUBPopoverViewController {
    
    private func loadToc() {
        guard let currentDocument = parentVC?.epubDocument else { return }
        
        
    }
    
    private func makeDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "TocItemCell", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = item.label
            config.secondaryText = item.page
            cell.contentConfiguration = config
            
            return cell
        }
    }
    
    private func applySnapshot(animates: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animates)
    }
}


extension EPUBPopoverViewController {
    
    enum Section: CaseIterable {
        case main
    }
}
