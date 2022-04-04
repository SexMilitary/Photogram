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
    func searchPhotos(query: String)
    func loadMore(query: String)
}

class SearchCollectionView: UICollectionView {
    
    weak var searchDelegate: SearchCollectionViewDelegate?
    
    private var isLoading = false
    
    var findedPhotos: SearchPhotos = SearchPhotos() {
        didSet {
            isLoading.toggle()
            reloadCollection()
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search..."
        bar.searchBarStyle = .minimal
        bar.sizeToFit()
        bar.isTranslucent = false
        bar.backgroundImage = UIImage()
        bar.delegate = self
        
        return bar
    }()
    
    private var layout = PinterestLayout()
    
    private let spacing: CGFloat = 10.0
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        layout.delegate = self
        
        delegate = self
        dataSource = self
        
        register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseId)
        
        contentInset.bottom = 100
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadCollection() {
        layout.prepare()
        reloadData()
    }
}

extension SearchCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return findedPhotos.results.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseId, for: indexPath) as? SearchCell
        cell?.info = findedPhotos.results[indexPath.item]
        
        return cell ?? UICollectionViewCell()
    }
}

extension SearchCollectionView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let existingCount = findedPhotos.results.count
        let totalCount = findedPhotos.totalPages
        guard existingCount < totalCount, let searchText = searchBar.text else { return }
        
        let contentHeight = scrollView.contentSize.height
        guard contentHeight != 0 else { return }
        
        let tabBarHeight = searchDelegate?.tabBarHeight ?? 0
        let buffer = bounds.height - (tabBarHeight + searchBar.frame.height + getStatusBarHeight())
        let offsetY = scrollView.contentOffset.y + searchBar.frame.height + getStatusBarHeight()
        
        if (contentHeight * 1.05 < (buffer + offsetY)) && !isLoading {
            isLoading.toggle()
            searchDelegate?.loadMore(query: searchText)
        }
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        
        return statusBarHeight
    }
}

extension SearchCollectionView: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard indexPath.item <= findedPhotos.results.endIndex - 1 else { return 0 }
        let width = (UIScreen.main.bounds.width / 2) - spacing
        
        return width / findedPhotos.results[indexPath.item].ratio
    }
}

extension SearchCollectionView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        findedPhotos.clear()
        searchDelegate?.searchPhotos(query: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        findedPhotos.clear()
        reloadCollection()
    }
}
