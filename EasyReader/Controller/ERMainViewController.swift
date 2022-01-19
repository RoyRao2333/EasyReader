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

class ERMainViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    private var subscribers: Set<AnyCancellable> = []
    
    private var models: Set<ERFile> = [] {
        didSet {
            applySnapshot()
        }
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ERFile>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ERFile>
    typealias CellRegistration = UICollectionView.CellRegistration<ERListCell, ERFile>

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Books"
        
        configureCollectionView()
        setupPublishers()
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
                guard let url = $0 else { return}
                
                self?.presentDocument(at: url)
//                logger.info("File at:", context: url)
            }
            .store(in: &subscribers)
        
        collectionView
            .didSelectItemPublisher
            .sink { [weak self] in
                self?.collectionView.deselectItem(at: $0, animated: false)
            }
            .store(in: &subscribers)
        
        collectionView
            .didSelectItemPublisher
            .map { [weak self] in
                guard let path = (self?.collectionView.cellForItem(at: $0) as? ERListCell)?.file?.path else { return nil }
                return URL(fileURLWithPath: path)
            }
            .assign(to: \.value, on: FileService.shared.current)
            .store(in: &subscribers)
    }
    
    private func configureCollectionView() {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
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
        guard let _ = collectionView.cellForItem(at: indexPath) as? ERListCell else { return }
        
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}


extension ERMainViewController {
    
    enum Section: CaseIterable {
        case main
    }
}
