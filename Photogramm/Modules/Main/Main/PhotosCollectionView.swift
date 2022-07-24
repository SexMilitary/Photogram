//
//  PhotosCollectionView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

class PhotosCollectionView: UICollectionView {
    
    enum Action {
        case didSelect(index: Int)
    }
    
    var action: ((Action, UICollectionViewCell) -> Void)?
    
    var photos: PhotoResponce?
    
    private let queue = OperationQueue()
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            action?(.didSelect(index: indexPath.item), cell)
        }
    }
}

extension PhotosCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.info = photos?[indexPath.item]
        cell.display(image: nil)
        
        let photoStr = photos?[indexPath.item].urls.small ?? ""
        let url = URL(string: photoStr)
        let op = NetworkImageOperation(url: url!)
        op.completionBlock = {
            DispatchQueue.main.async {
                guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else {
                    return
                }
                
                cell.display(image: op.image)
            }
        }
        
        queue.addOperation(op)
        
        return cell
    }
    
}
