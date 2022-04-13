//
//  PhotoCell.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let reuseId = "PhotoCell"
    
    private lazy var img: WebImageView = {
        let img = WebImageView()
        img.backgroundColor =  UIColor.black.withAlphaComponent(0.08)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        img.alpha = 0
        
        return img
    }()
    
    private lazy var userImg: WebImageView = {
        let img = WebImageView()
        img.backgroundColor =  UIColor.black.withAlphaComponent(0.08)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        img.alpha = 0
        img.layer.cornerRadius = 15
        
        img.flashing()
        
        return img
    }()
    
    private lazy var userLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 22, weight: .bold)
        lab.translatesAutoresizingMaskIntoConstraints = false
        
        return lab
    }()
    
    private lazy var likeLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        
        return lab
    }()
    
    private lazy var collectionsLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .right
        
        return lab
    }()
    
    private lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.textColor = .black
        lab.numberOfLines = 2
        lab.textAlignment = .center
        lab.lineBreakMode = .byWordWrapping
        lab.font = .systemFont(ofSize: 14)
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
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
            
            userImg.fadeIn(duration: 0.2)
            userImg.set(imageURL: info?.user.profileImage.large) {
                self.userImg.stopFlashing()
            }
            userLab.text = info?.user.username
            
            likeLab.attributedText = String.createAttributedString(firstString: "\(info?.likes ?? 0)", secondString: "likes",
                                                                        firstTextColor: .black, secondTextColor: .lightGray,
                                                                        firstFont: .systemFont(ofSize: 14, weight: .bold),
                                                                        secondFont: .systemFont(ofSize: 14, weight: .medium))
            
            collectionsLab.attributedText = String.createAttributedString(firstString: "\(info?.user.id ?? "")", secondString: "id",
                                                                   firstTextColor: .black, secondTextColor: .lightGray,
                                                                   firstFont: .systemFont(ofSize: 14, weight: .bold),
                                                                   secondFont: .systemFont(ofSize: 14, weight: .medium))
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
        
        backgroundColor = UIColor("#e4cece")
        addSubview(img)
        addSubview(descLab)
        addSubview(indicator)
        
        addSubview(likeLab)
        addSubview(collectionsLab)
        
        img.addSubview(userImg)
        img.addSubview(userLab)
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
            descLab.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            indicator.centerXAnchor.constraint(equalTo: img.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: img.centerYAnchor),
            
            likeLab.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            likeLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            likeLab.trailingAnchor.constraint(equalTo: collectionsLab.leadingAnchor, constant: 10),
            
            collectionsLab.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            collectionsLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            userImg.widthAnchor.constraint(equalToConstant: 30),
            userImg.heightAnchor.constraint(equalToConstant: 30),
            userImg.leadingAnchor.constraint(equalTo: img.leadingAnchor, constant: 30),
            userImg.bottomAnchor.constraint(equalTo: img.bottomAnchor, constant: -20),
            
            userLab.leadingAnchor.constraint(equalTo: userImg.trailingAnchor, constant: 10),
            userLab.trailingAnchor.constraint(equalTo: img.trailingAnchor, constant: -10),
            userLab.bottomAnchor.constraint(equalTo: img.bottomAnchor, constant: -20)
        ])
    }
    
    func assignPhoto() {
        guard let data = info else {
            return
        }
        
        indicator.startAnimating()
        img.set(imageURL: data.urls.small) { [weak self] in
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
