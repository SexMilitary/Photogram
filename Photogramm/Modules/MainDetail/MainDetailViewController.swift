//
//  MainDetailViewController.swift
//  Photogramm
//
//  Created by Максим Чикинов on 25.04.2022.
//

import UIKit

final class MainDetailViewController: UIViewController {
    
    var viewModel: Photo
    
    init(viewModel: Photo) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MainDetailViewController {
    func setupViews() {
        view.backgroundColor = .background
        view = DetailPhotoView(viewModel: viewModel)
    }
}
