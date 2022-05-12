//
//  FilterCollectionViewCell.swift
//  Photogramm
//
//  Created by User on 12.05.2022.
//

import UIKit

final class FilterCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "FilterCollectionViewCell"
    
    var isSelect: Bool = false
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        border()
        
        addSubview(nameLabel)
        
        backgroundColor = .white
        
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: -10).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        nameLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
    }
    
    func fill(_ model: SearchFilter) {
        nameLabel.text = model.title
        select(model.isSelect)
    }
    
    func select(_ state: Bool) {
        nameLabel.textColor = state ? Constants.textSelectedColor : Constants.textColor
        backgroundColor = state ? Constants.backgroundSelectedColor : Constants.backgroundColor
        isSelect = state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.textColor = Constants.textColor
        backgroundColor = Constants.backgroundColor
        isSelect = false
    }
    
    struct Constants {
        static let backgroundColor: UIColor = .white
        static let backgroundSelectedColor: UIColor = .darkGray
        static let textColor: UIColor = .lightGray
        static let textSelectedColor: UIColor = .lightText
    }
}
