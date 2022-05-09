//
//  TabNavigationMenu.swift
//  Photogramm
//
//  Created by Максим Чикинов on 11.04.2022.
//

import UIKit

class TabNavigationMenu: UIView {
    
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        
        layer.backgroundColor = UIColor.tabBarBackground?.cgColor
        layer.cornerRadius = 12
        clipsToBounds = true
        
        border()
        
        for i in 0..<menuItems.count {
            let itemWidth = (frame.width - 40) / CGFloat(menuItems.count)
            let leadingAnchor = itemWidth * CGFloat(i)
            
            let itemView = createTabItem(item: menuItems[i])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = i
            
            addSubview(itemView)
            
            NSLayoutConstraint.activate([
                itemView.heightAnchor.constraint(equalTo: heightAnchor),
                itemView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: leadingAnchor),
                itemView.topAnchor.constraint(equalTo: topAnchor),
            ])
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
        activateTab(tab: 0)
    }
    
    private func createTabItem(item: TabItem) -> UIView {
        let tabBarItem = UIView(frame: CGRect.zero)
        let itemTitleLabel = UILabel(frame: CGRect.zero)
        let itemIconView = UIImageView(frame: CGRect.zero)
        
        let itemColor = UIColor.black.withAlphaComponent(0.7)
        
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.clipsToBounds = true
        itemTitleLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        itemTitleLabel.textColor = itemColor
        
        itemIconView.image = item.icon.withRenderingMode(.alwaysOriginal).withTintColor(itemColor)
        itemIconView.translatesAutoresizingMaskIntoConstraints = false
        itemIconView.clipsToBounds = true
        
        tabBarItem.layer.backgroundColor = UIColor.clear.cgColor
        tabBarItem.addSubview(itemIconView)
        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.translatesAutoresizingMaskIntoConstraints = false
        tabBarItem.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            itemIconView.topAnchor.constraint(equalTo: tabBarItem.topAnchor, constant: 12),
            itemIconView.heightAnchor.constraint(equalToConstant: 25),
            itemIconView.widthAnchor.constraint(equalToConstant: 25),
            itemIconView.centerXAnchor.constraint(equalTo: tabBarItem.centerXAnchor),
            itemIconView.leadingAnchor.constraint(equalTo: tabBarItem.leadingAnchor, constant: 35),
            
            itemTitleLabel.widthAnchor.constraint(equalTo: tabBarItem.widthAnchor),
            itemTitleLabel.topAnchor.constraint(equalTo: itemIconView.bottomAnchor, constant: 4)
        ])
        
        tabBarItem.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap)))
        
        return tabBarItem
    }
    
    @objc
    private func handleTap(_ sender: UIGestureRecognizer) {
        self.switchTab(from: self.activeItem, to: sender.view!.tag)
    }
    
    private func switchTab(from: Int, to: Int) {
        deactivateTab(tab: from)
        activateTab(tab: to)
    }
    
    private func activateTab(tab: Int) {
        let tabToActivate = subviews[tab]
        let borderWidth = tabToActivate.frame.size.width - 20
        
        let view = UIView()
        view.tag = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor("#7E5A5A")
        view.alpha = 0
        view.frame = .init(origin: .init(x: 10, y: 0), size: .init(width: borderWidth, height: 4))
        
        tabToActivate.addSubview(view)
        
        view.fadeIn(duration: 0.2)
        
        self.itemTapped?(tab)
        
        activeItem = tab
    }
    
    private func deactivateTab(tab: Int) {
        let inactiveTab = self.subviews[tab]
        let viewToRemove = inactiveTab.subviews.first(where: { $0.tag == 1 })
        
        UIView.animate(withDuration: 0.2) {
            viewToRemove?.alpha = 0
        } completion: { _ in
            viewToRemove?.removeFromSuperview()
        }
    }
    
}
