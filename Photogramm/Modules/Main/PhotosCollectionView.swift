//
//  PhotosCollectionView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

class PhotosCollectionView: UICollectionView, UICollectionViewDelegate {
    
    var photos: Photos?
    
    private var layout = UICollectionViewFlowLayout()
    
    private let spacing: CGFloat = 10.0
    
    private var firstImageHeight: CGFloat = 0.0
    
    init() {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        layout.minimumLineSpacing = 20
        delegate = self
        dataSource = self
        
        register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension PhotosCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let photos = photos else { return .zero}
        
        let width = UIScreen.main.bounds.width - (spacing * 2)
        firstImageHeight = calculateImageHeight(sourceImage: photos[indexPath.row],
                                                 scaledToWidth: width)
        let textHeight = labelHeight(text: photos[indexPath.row].urls.small,
                                     cellWidth: width)
        let imgHeight = firstImageHeight
        
        return CGSize(width: width, height: (imgHeight + textHeight + spacing * 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
    
    private func calculateImageHeight(sourceImage: Photo, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(sourceImage.width)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(sourceImage.height) * scaleFactor
        return newHeight
    }
    
    private func labelHeight(text: String , cellWidth: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14)
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
}
