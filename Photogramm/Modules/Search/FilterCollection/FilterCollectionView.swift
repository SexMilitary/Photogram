//
//  FilterCollectionView.swift
//  Photogramm
//
//  Created by User on 12.05.2022.
//

import UIKit

protocol FilterCollectionViewDelegate: AnyObject {
    func didSelectItem(model: SearchFilter)
}

final class FilterCollectionView: UICollectionView {
    
    weak var actionsDelegate: FilterCollectionViewDelegate?
    
    private var model = SearchFilters()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = #colorLiteral(red: 0.9589126706, green: 0.9690223336, blue: 0.9815708995, alpha: 1)
        delegate = self
        dataSource = self
        register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: FilterCollectionViewCell.reuseId)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 10
        contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cells: SearchFilters) {
        self.model = cells
    }
    
    func select(_ item: Int) {
        setSelections(self, IndexPath(row: item, section: 0))
    }
    
}

extension FilterCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseId, for: indexPath) as! FilterCollectionViewCell
        cell.fill(model.filters[indexPath.item])
        return cell
    }
}

extension FilterCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        setSelections(collectionView, indexPath)
        actionsDelegate?.didSelectItem(model: self.model.filters[indexPath.item])
    }
    
    fileprivate func setSelections(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        /// Deselect
        if let filerCells = collectionView.subviews as? [FilterCollectionViewCell] {
            let previosSelectedCell = filerCells.first(where: { $0.isSelect })
            previosSelectedCell?.select(false)
        }
        model.filters.first(where: { $0.isSelect })?.isSelect.toggle()
        /// Select
        let cell = collectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        cell.select(true)
        model.filters[indexPath.item].isSelect.toggle()
    }
}

extension FilterCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}
