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
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor =  UIColor.black.withAlphaComponent(0.08)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        img.alpha = 0
        
        return img
    }()
    
    private lazy var userImg: WebImageView = {
        let img = WebImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor =  UIColor.black.withAlphaComponent(0.08)
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        img.alpha = 0
        img.layer.cornerRadius = 15
        
        img.flashing()
        
        return img
    }()
    
    private lazy var userLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.font = .systemFont(ofSize: 22, weight: .bold)
        
        return lab
    }()
    
    private lazy var leftDetailLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        
        return lab
    }()
    
    private lazy var rightDetailLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .right
        
        return lab
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private lazy var descLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .black
        lab.numberOfLines = 0
        lab.textAlignment = .left
        lab.lineBreakMode = .byWordWrapping
        lab.font = .systemFont(ofSize: 14)
        lab.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        return lab
    }()
    
    private lazy var dateLab: UILabel = {
        let lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .gray
        lab.numberOfLines = 1
        lab.textAlignment = .right
        lab.font = .systemFont(ofSize: 12, weight: .light)
        
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
            assignPhoto()
            
            userImg.fadeIn(duration: 0.2)
            userImg.set(imageURL: info?.user.profileImage.large) {
                self.userImg.stopFlashing()
            }
            userLab.text = info?.user.username
            
            leftDetailLab.attributedText = String.createAttributedString(firstString: "\(info?.likes ?? 0)", secondString: "Likes",
                                                                         firstTextColor: .black, secondTextColor: .lightGray,
                                                                         firstFont: .systemFont(ofSize: 14, weight: .bold),
                                                                         secondFont: .systemFont(ofSize: 12, weight: .medium))
            
            if let locationStr = info?.user.formatedLocation {
                rightDetailLab.attributedText = String.createAttributedString(firstString: "\(locationStr)", secondString: "Location",
                                                                              firstTextColor: .black, secondTextColor: .lightGray,
                                                                              firstFont: .systemFont(ofSize: 14, weight: .bold),
                                                                              secondFont: .systemFont(ofSize: 12, weight: .medium))
            }
            
            descLab.text = info?.photoDescription
            
            let createdDate = info?.createdAt.convertToDate()
            dateLab.text = DateFormatter().getFormattedDate(date: createdDate, format: .shortDateShortYearFormatWithHourAndMinutes)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        
        border()
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
        
        let firstColor = UIColor("#f7f8f9")
        let secondColor = UIColor("#f3f4f7")
        addGradient(colors: [firstColor, secondColor], locations: [0, 1], startPoint: CGPoint(x: 0.0, y: 1.5), endPoint: CGPoint(x: 1.0, y: 2.0), type: .axial)
        
        addSubview(img)
        addSubview(indicator)
        
        addSubview(leftDetailLab)
        addSubview(rightDetailLab)
        
        addSubview(separator)
        addSubview(descLab)
        
        addSubview(dateLab)
        
        img.addSubview(userImg)
        img.addSubview(userLab)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            img.topAnchor.constraint(equalTo: topAnchor),
            img.leadingAnchor.constraint(equalTo: leadingAnchor),
            img.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: img.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: img.centerYAnchor),
            
            leftDetailLab.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            leftDetailLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            leftDetailLab.trailingAnchor.constraint(equalTo: rightDetailLab.leadingAnchor, constant: 10),
            
            rightDetailLab.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 20),
            rightDetailLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            separator.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 50),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            descLab.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 10),
            descLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            descLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            dateLab.topAnchor.constraint(equalTo: descLab.bottomAnchor, constant: 10),
            dateLab.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dateLab.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dateLab.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
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
        super.prepareForReuse()
        
        img.image = nil
        descLab.text = nil
    }
}
