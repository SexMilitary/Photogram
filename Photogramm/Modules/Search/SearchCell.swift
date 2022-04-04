//
//  SearchCell.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

class SearchCell: UICollectionViewCell {
    
    static let reuseId = "SearchCell"
    
    private lazy var img: WebImageView = {
        let img = WebImageView()
        img.backgroundColor =  UIColor.black.withAlphaComponent(0.08)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        img.alpha = 0
        
        return img
    }()
    
    private lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.numberOfLines = 1
        lab.textAlignment = .center
        lab.lineBreakMode = .byWordWrapping
        lab.font = .systemFont(ofSize: 14)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return lab
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        view.tintColor = .systemBlue
        
        return view
    }()
    
    var info: Photo? {
        didSet {
            descLab.text = info?.photoDescription
            assignPhoto()
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
        info = nil
    }
    
    func setupViews() {
        layer.cornerRadius = 12
        clipsToBounds = true
        
        backgroundColor = UIColor.black.withAlphaComponent(0.04)
        addSubview(img)
        addSubview(descLab)
        addSubview(indicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: topAnchor),
            img.leadingAnchor.constraint(equalTo: leadingAnchor),
            img.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            descLab.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 10),
            descLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descLab.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            indicator.centerXAnchor.constraint(equalTo: img.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: img.centerYAnchor)
        ])
    }
    
    func assignPhoto() {
        guard let data = info else {
            return
        }
        
        indicator.startAnimating()
        img.set(imageURL: data.urls.thumb) { [weak self] in
            self?.indicator.stopAnimating()
            
            UIView.animate(withDuration: 0.3) {
                self?.img.alpha = 1
            }
        }
    }
   
    override func prepareForReuse() {
        img.image = nil
    }
}
