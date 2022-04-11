//
//  PhotosCollectionView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

class PhotosCollectionView: UICollectionView {
    
    var photos: Photos?
    
    private var layout = CardsCollectionViewLayout()
    
    private let spacing: CGFloat = 10.0
    
    private var firstImageHeight: CGFloat = 0.0
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotosCollectionView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.y = 0
    }
}

extension PhotosCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell
        cell?.info = photos?[indexPath.item]
        return cell ?? UICollectionViewCell()
    }
    
}
