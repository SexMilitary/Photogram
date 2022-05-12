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
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
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
        nameLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
    }
    
    func fill(_ text: String) {
        nameLabel.text = text
    }
    
    func select(_ state: Bool) {
        nameLabel.textColor = state ? #colorLiteral(red: 0.007841579616, green: 0.007844132371, blue: 0.007841020823, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        backgroundColor = state ? #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        isSelect = state
        
        print("\(nameLabel.text) is select \(isSelect)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
