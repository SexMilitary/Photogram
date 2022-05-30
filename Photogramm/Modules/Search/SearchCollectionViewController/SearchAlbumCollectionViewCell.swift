//
//  SearchAlbumCollectionViewCell.swift
//  Photogramm
//
//  Created by Максим Чикинов on 30.05.2022.
//

import Foundation
import UIKit

class SearchAlbumCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "SearchAlbumCollectionViewCell"
    
    private lazy var imageView: WebImageView = {
        let img = WebImageView()
        img.backgroundColor =  UIColor.black.withAlphaComponent(0.08)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 10
        img.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        img.setContentHuggingPriority(.init(0), for: .vertical)
        
        return img
    }()
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black.withAlphaComponent(0.8)
        lab.numberOfLines = 1
        lab.textAlignment = .right
        lab.font = .systemFont(ofSize: 18, weight: .bold)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        lab.setContentHuggingPriority(.init(1000), for: .vertical)
        
        return lab
    }()
    
    private lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black.withAlphaComponent(0.8)
        lab.numberOfLines = 1
        lab.textAlignment = .right
        lab.font = .systemFont(ofSize: 14, weight: .light)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        lab.setContentHuggingPriority(.init(1000), for: .vertical)
        
        return lab
    }()
    
    var model: Collection? {
        didSet {
            guard let model = model else { return }
            
            titleLab.text = model.title.uppercased()
            descLab.text = model.user.username.capitalized
            imageView.set(imageURL: model.coverPhoto.urls.thumb)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        model = nil
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        
        addSubview(imageView)
        addSubview(titleLab)
        addSubview(descLab)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            titleLab.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            descLab.topAnchor.constraint(equalTo: titleLab.bottomAnchor, constant: 10),
            descLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            descLab.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
   
    override func prepareForReuse() {
        imageView.image = nil
    }
}
