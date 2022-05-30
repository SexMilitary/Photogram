//
//  SearchCollectionView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

protocol SearchCollectionViewDelegate: AnyObject {
    var tabBarHeight: CGFloat { get }
    func searchPhotos()
    func loadMore()
    func didSelect(model: Photo)
}

class SearchCollectionViewController: UIViewController, PageableController {
    
    weak var searchDelegate: SearchCollectionViewDelegate?
    
    internal var number: Int
    
    private var isLoading = false
    
    var model: SearchCollectionViewModel? {
        didSet {
            isLoading = false
            reloadCollection()
            
            loadingView.stop()
        }
    }
    
    private lazy var layout: UICollectionViewLayout = {
        let layout: UICollectionViewLayout
        switch number {
        case 0:
            layout = PinterestLayout()
            (layout as? PinterestLayout)?.delegate = self
        default:
            layout = UICollectionViewFlowLayout()
        }
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(SearchCell.self,
                      forCellWithReuseIdentifier: SearchCell.reuseId)
        view.register(SearchAlbumCollectionViewCell.self,
                      forCellWithReuseIdentifier: SearchAlbumCollectionViewCell.reuseId)
        view.keyboardDismissMode = .onDrag
        view.contentInset.top = number == 0 ? 50 : 70
        view.contentInset.bottom = 100
        view.verticalScrollIndicatorInsets.top = 50
        
        return view
    }()
    
    lazy var loadingView = LoadingView()
    private var loaderBottomAnchor: NSLayoutConstraint?
    
    private let spacing: CGFloat = 10.0
    
    init(number: Int) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalToConstant: 250),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        loaderBottomAnchor = loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                                 constant: 0)
        loaderBottomAnchor?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadCollection() {
        layout.prepare()
        collectionView.reloadData()
    }
}

extension SearchCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        switch model {
        case .photo(let model):
            return model.results.count
        case .collection(let model):
            return model.results.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = model else { return UICollectionViewCell() }
        switch model {
        case .photo(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseId, for: indexPath) as? SearchCell
            cell?.info = model.results[indexPath.item]
            cell?.shadowDecorate(radius: 18)
            
            return cell ?? UICollectionViewCell()
        case .collection(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchAlbumCollectionViewCell.reuseId,
                                                          for: indexPath) as? SearchAlbumCollectionViewCell
            cell?.model = model.results[indexPath.item]
            cell?.shadowDecorate(radius: 10, offset: CGSize(width: 0, height: 0))
            
            return cell ?? UICollectionViewCell()
        }
    }
}

extension SearchCollectionViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let existingCount: Int
        let totalCount: Int
        
        guard let model = model else { return }
        switch model {
        case .photo(model: let model):
            existingCount = model.results.count
            totalCount = model.totalPages
        case .collection(model: let model):
            existingCount = model.results.count
            totalCount = model.totalPages
        }
        
        guard existingCount < totalCount else { return }
        
        let contentHeight = scrollView.contentSize.height
        guard contentHeight != 0 else { return }
        
        let tabBarHeight = searchDelegate?.tabBarHeight ?? 0
        let buffer = view.bounds.height - (tabBarHeight + view.getStatusBarHeight())
        let offsetY = scrollView.contentOffset.y + view.getStatusBarHeight()
        
        if (contentHeight * 0.8 < (buffer + offsetY)) && !isLoading {
            isLoading = true
            searchDelegate?.loadMore()
            
            loadingView.layoutSubviewsAnimated()
            loadingView.start()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        searchDelegate?.didSelect(model: findedPhotos.results[indexPath.item])
    }
}

extension SearchCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 40, height: 300)
    }
}

extension SearchCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard let model = model else { return 0 }
        switch model {
        case .photo(model: let model):
            guard indexPath.item <= model.results.endIndex - 1 else { return 0 }
            let width = (UIScreen.main.bounds.width / 2) - spacing
            return width / model.results[indexPath.item].ratio
        case .collection(_):
            return 200
        }
    }
}
