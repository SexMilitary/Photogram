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
        img.layer.cornerRadius = 18
        img.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return img
    }()
    
    private lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.black.withAlphaComponent(0.8)
        lab.numberOfLines = 1
        lab.textAlignment = .center
        lab.lineBreakMode = .byWordWrapping
        lab.font = .systemFont(ofSize: 14, weight: .bold)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return lab
    }()
    
    private lazy var likeImage: UIImageView = {
        let view = UIImageView()
        if let image = UIImage(systemName: "heart.fill") {
            view.image = image.withRenderingMode(.alwaysOriginal).withTintColor(UIColor.black.withAlphaComponent(0.8))
        }
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
            descLab.text = "\(info?.likes ?? 0)"
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
        backgroundColor = UIColor.white
        addSubview(img)
        addSubview(likeImage)
        addSubview(descLab)
        addSubview(indicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: topAnchor),
            img.leadingAnchor.constraint(equalTo: leadingAnchor),
            img.trailingAnchor.constraint(equalTo: trailingAnchor),
            img.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            
            likeImage.trailingAnchor.constraint(equalTo: descLab.leadingAnchor, constant: -5),
            likeImage.widthAnchor.constraint(equalToConstant: 16),
            likeImage.heightAnchor.constraint(equalToConstant: 16),
            likeImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            descLab.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 25 / 2),
            descLab.centerYAnchor.constraint(equalTo: likeImage.centerYAnchor),
            
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
