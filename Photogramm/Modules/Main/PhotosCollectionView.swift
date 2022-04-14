//
//  PhotosCollectionView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

class PhotosCollectionView: UICollectionView {
    
    var photos: PhotoResponce?
    
    init() {
        let layout = CardsCollectionViewLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        
        let bounds = UIScreen.main.bounds
        let width = bounds.width - 75
        let height = bounds.height * 0.6
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.spacing = 15
        
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
