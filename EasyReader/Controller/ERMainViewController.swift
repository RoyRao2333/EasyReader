//
//  ERMainViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers
import SnapKit
import Combine
import CombineCocoa
import Defaults
import EPUBKit

class ERMainViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    private var subscribers: Set<AnyCancellable> = []
    
    private var models: [ERFile] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                
                weakSelf.applySnapshot()
                #warning("Fixme: Placeholder View")
                weakSelf.models.isEmpty
                    ? weakSelf.collectionView.showPlaceholder()
                    : weakSelf.collectionView.removePlaceholder()
            }
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ERFile>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ERFile>
    typealias CellRegistration = UICollectionView.CellRegistration<ERListCell, ERFile>

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Library"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "book.fill"),
            style: .plain,
            target: self,
            action: #selector(openEpub(_:))
        )
        
        configureCollectionView()
        setupPublishers()
    }
}


// MARK: Actions -
extension ERMainViewController {
    
    @IBAction private func openEpub(_ sender: UIBarButtonItem) {
        guard let epubPath = Bundle.main.path(forResource: "TheSwiftProgrammingLanguageSwift55", ofType: "epub") else { return }
        let epubURL = URL(fileURLWithPath: epubPath)
        
        let epubViewController = EPUBViewController.instantiate(withStoryboard: .main)
        epubViewController.epubDocument = EPUBDocument(url: epubURL)
        epubViewController.modalPresentationStyle = .fullScreen
        epubViewController.modalTransitionStyle = .crossDissolve
        present(epubViewController, animated: true, completion: nil)
    }
}


// MARK: Private Methods -
extension ERMainViewController {
    
    private func setupPublishers() {
        Defaults
            .publisher(.storage)
            .sink { [weak self] in
                self?.models = $0.newValue
            }
            .store(in: &subscribers)
        
        FileService.shared.current
            .sink { [weak self] in
                guard let url = $0 else { return }
                
                self?.presentDocument(at: url)
            }
            .store(in: &subscribers)
    }
    
    private func configureCollectionView() {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        layoutConfig.trailingSwipeActionsConfigurationProvider = { indexPath in
            let del = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completion in
                guard let file = (self?.collectionView.cellForItem(at: indexPath) as? ERListCell)?.file else { return }
                
                do {
                    try FileManager.default.removeItem(atPath: file.path)
                    Defaults[.storage].removeAll { $0.path == file.path }
                    completion(true)
                } catch {
                    logger.warning("Remove item failed with error:", context: error)
                    completion(false)
                }
            }
            return UISwipeActionsConfiguration(actions: [del])
        }
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        collectionView.alwaysBounceVertical = true
        collectionView.delaysContentTouches = false
        collectionView.allowsMultipleSelection = false
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { make in
            make.topMargin.equalTo(view.snp.topMargin)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func makeDataSource() -> DataSource {
        let cellRegistration = CellRegistration { cell, indexPath, item in
            cell.file = item
            cell.accessories = [.disclosureIndicator()]
        }
        
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        return dataSource
    }
    
    private func applySnapshot(animates: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(Array(weakSelf.models), toSection: .main)
            
            weakSelf.dataSource.apply(snapshot, animatingDifferences: animates)
        }
    }
    
    private func presentDocument(at documentURL: URL) {
        let _ = documentURL.startAccessingSecurityScopedResource()
        
        let type = UTType(filenameExtension: documentURL.pathExtension) ?? .plainText
        switch type {
            case .pdf:
                let pdfViewController = PDFViewController.instantiate(withStoryboard: .main)
                pdfViewController.pdfDocument = PDFDocument(url: documentURL)
                pdfViewController.modalPresentationStyle = .fullScreen
                pdfViewController.modalTransitionStyle = .crossDissolve
                present(pdfViewController, animated: true, completion: nil)
                
            case .epub:
                let epubViewController = EPUBViewController.instantiate(withStoryboard: .main)
                
                epubViewController.modalPresentationStyle = .fullScreen
                epubViewController.modalTransitionStyle = .crossDissolve
                present(epubViewController, animated: true, completion: nil)
                
            case .plainText, .rtf, .rtfd:
                fallthrough
                
            default:
                let documentViewController = DocumentViewController.instantiate(withStoryboard: .main)
                documentViewController.document = Document(fileURL: documentURL)
                documentViewController.modalPresentationStyle = .fullScreen
                documentViewController.modalTransitionStyle = .crossDissolve
                present(documentViewController, animated: true, completion: nil)
        }
        documentURL.stopAccessingSecurityScopedResource()
    }
}


// MARK: CollectionView Delegate -
extension ERMainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .systemGray.withAlphaComponent(0.1)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? ERListCell,
            let path = cell.file?.path
        else { return }
        
        collectionView.deselectItem(at: indexPath, animated: false)
        
        FileService.shared.current.value = URL(fileURLWithPath: path)
    }
}


extension ERMainViewController {
    
    enum Section: CaseIterable {
        case main
    }
}
