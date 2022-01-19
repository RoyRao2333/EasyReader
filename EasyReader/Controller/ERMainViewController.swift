//
//  ERMainViewController.swift
//  EasyReader
//
//  Created by roy on 2022/1/18.
//

import UIKit
import PDFKit
import UniformTypeIdentifiers
import QuickLookThumbnailing
import SnapKit

class ERMainViewController: UIViewController {
    private var collectionView: UICollectionView!
    
    private lazy var dataSource = makeDataSource()
    
    private var models: [ERFile] = [
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_1", fileType: .txt, path: ""),
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_2", fileType: .pdf, path: ""),
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_3", fileType: .pdf, path: ""),
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_4", fileType: .txt, path: ""),
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_5", fileType: .epub, path: ""),
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_6", fileType: .rtf, path: ""),
        ERFile(thumbnail: UIImage(systemName: "paperplane.fill"), fileName: "File_7", fileType: .rtfd, path: ""),
    ]
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ERFile>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ERFile>
    typealias CellRegistration = UICollectionView.CellRegistration<ERListCell, ERFile>

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Books"
        
        configureCollectionView()
        applySnapshot()
    }
}


// MARK: Private Methods -
extension ERMainViewController {
    
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
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(models, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animates)
    }
    
    private func presentDocument(at documentURL: URL) {
        let type = UTType(filenameExtension: documentURL.pathExtension) ?? .plainText
        
        let _ = documentURL.startAccessingSecurityScopedResource()
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
    
    private func thumbnail(for url: URL, _ completion: @escaping (UIImage?) -> Void) {
        let request = QLThumbnailGenerator.Request(
            fileAt: url,
            size: CGSize(width: 50, height: 50),
            scale: 1,
            representationTypes: .lowQualityThumbnail
        )
        
        QLThumbnailGenerator.shared.generateRepresentations(for: request) { thumbnail, _, _ in
            completion(thumbnail?.uiImage)
        }
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
