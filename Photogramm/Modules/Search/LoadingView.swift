//
//  LoadingReusableView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 31.03.2022.
//

import UIKit

final class LoadingView: UIView {
    
    private var isPlay = false
    
    static let reuseId = "LoadingCollectionViewCell"
    
    lazy var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBlue
        view.color = .white
        view.layer.cornerRadius = 25
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(loader)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            loader.widthAnchor.constraint(equalToConstant: 50),
            loader.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        guard !isPlay else { return }
        isPlay.toggle()
        loader.startAnimating()
        loader.fadeIn(duration: 0.2)
    }
    
    func stop() {
        guard isPlay else { return }
        isPlay.toggle()
        loader.stopAnimating()
        loader.fadeOut(duration: 0.2)
    }
}
