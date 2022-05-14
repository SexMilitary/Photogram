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
    
    private func setSelections(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        performDeselected(collectionView)
        performSelected(collectionView, indexPath)
        scrollIfCellHidden(collectionView: collectionView, indexPath: indexPath)
    }
    
    private func performDeselected(_ collectionView: UICollectionView) {
        if let filerCells = collectionView.subviews as? [FilterCollectionViewCell] {
            let previosSelectedCell = filerCells.first(where: { $0.isSelect })
            previosSelectedCell?.select(false)
        }
        /// Deselect model item
        model.filters.first(where: { $0.isSelect })?.isSelect.toggle()
    }
    
    private func performSelected(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        cell.select(true)
        /// Select model item
        model.filters[indexPath.item].isSelect.toggle()
    }
    
    private func scrollIfCellHidden(collectionView: UICollectionView, indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FilterCollectionViewCell else { return }
        
        let visibility = isVisible(cell: cell, on: collectionView)
        if !visibility.isVisible {
            let xOffset = visibility.necesseryOffset
            collectionView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        }
    }
    
    private func isVisible(cell: FilterCollectionViewCell, on collectionView: UICollectionView) -> (isVisible: Bool, necesseryOffset: CGFloat) {
        let leftInset = collectionView.contentInset.left
        let cellWidth = cell.frame.width
        let cellX = cell.frame.origin.x
        let offsetXPosition = collectionView.contentOffset.x + leftInset
        let screenWidth = UIScreen.main.bounds.width
        
        let isVisibleFromLeft = offsetXPosition <= cellX
        if !isVisibleFromLeft {
            let hiddenCellWidth = offsetXPosition - cellX
            let necesseryOffset = offsetXPosition - hiddenCellWidth - leftInset
            
            return (isVisible: false, necesseryOffset: necesseryOffset)
        }
        
        let cellMaxY = cellX + cellWidth
        let contentMaxVisibleY = offsetXPosition + screenWidth
        let isVisibleFromRight = cellMaxY <= contentMaxVisibleY
        
        if !isVisibleFromRight {
            let visibleCellWidth = contentMaxVisibleY - cellX
            let hiddenCellWidth = cellWidth - visibleCellWidth
            let necesseryOffset = offsetXPosition + hiddenCellWidth + leftInset
            
            return (isVisible: false, necesseryOffset: necesseryOffset)
        }
        
        return (isVisible: true, necesseryOffset: 0)
    }
}

extension FilterCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 40)
    }
}
