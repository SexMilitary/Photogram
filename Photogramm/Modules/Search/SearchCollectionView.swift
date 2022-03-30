//
//  SearchCollectionView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

protocol SearchCollectionViewDelegate: AnyObject {
    func searchPhotos(page: Int, query: String)
}

class SearchCollectionView: UICollectionView {
    
    weak var searchDelegate: SearchCollectionViewDelegate?
    
    var findedPhotos: SearchPhotos?
    
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
    
    private var firstImageHeight: CGFloat = 0.0
    private var secondImageHeight: CGFloat = 0.0
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        layout.delegate = self
        
        delegate = self
        dataSource = self
        
        register(SearchCell.self, forCellWithReuseIdentifier: "SearchCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return findedPhotos?.results.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCell", for: indexPath) as? SearchCell
        cell?.info = findedPhotos?.results[indexPath.item]
        
        return cell ?? UICollectionViewCell()
    }
}

extension SearchCollectionView: UICollectionViewDelegate {
    
}

extension SearchCollectionView: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        let width = (UIScreen.main.bounds.width / 2) - spacing
        return width / (findedPhotos?.results[indexPath.item].ratio ?? 1)
    }
}

extension SearchCollectionView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDelegate?.searchPhotos(page: 1, query: searchText)
    }
}
