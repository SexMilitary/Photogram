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

class SearchCollectionView: UIView {
    
    weak var searchDelegate: SearchCollectionViewDelegate?
    
    private var isLoading = false
    
    var findedPhotos: SearchPhotos = SearchPhotos() {
        didSet {
            isLoading.toggle()
            reloadCollection()
            
            loadingView.stop()
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
        bar.searchTextField.delegate = self
        bar.searchTextField.returnKeyType = .done
        
        return bar
    }()
    
    private var layout = PinterestLayout()
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.dataSource = self
        view.register(SearchCell.self, forCellWithReuseIdentifier: SearchCell.reuseId)
        view.keyboardDismissMode = .onDrag
        view.contentInset.bottom = 100
        
        return view
    }()
    
    lazy var loadingView = LoadingView()
    private var loaderBottomAnchor: NSLayoutConstraint?
    
    private let spacing: CGFloat = 10.0
    
    init() {
        super.init(frame: .zero)
        
        layout.delegate = self
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.heightAnchor.constraint(equalToConstant: 100),
            loadingView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        loaderBottomAnchor = loadingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                                                 constant: 0)
        loaderBottomAnchor?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func reloadCollection() {
        layout.prepare()
        collectionView.reloadData()
    }
}

extension SearchCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return findedPhotos.results.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCell.reuseId, for: indexPath) as? SearchCell
        cell?.info = findedPhotos.results[indexPath.item]
        cell?.shadowDecorate(radius: 18)
        
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
        
        if (contentHeight * 0.8 < (buffer + offsetY)) && !isLoading {
            isLoading.toggle()
            searchDelegate?.loadMore(query: searchText)
            
            loadingView.layoutSubviewsAnimated()
            loadingView.start()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.searchTextField.resignFirstResponder()
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

extension SearchCollectionView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}
