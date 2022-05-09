//
//  DetailPhotoView.swift
//  Photogramm
//
//  Created by Максим Чикинов on 05.05.2022.
//

import UIKit

final class DetailPhotoView: UIView {
    
    private var viewModel: Photo
    
    private lazy var image: WebImageView = {
        let image = WebImageView()
        image.contentMode = .scaleAspectFill
        image.set(imageURL: viewModel.urls.small)
        image.set(imageURL: viewModel.urls.regular) { [weak self] in
            guard let self = self else { return }
            self.activity.stopAnimating()
        }
        
        return image
    }()
    
    private lazy var activity: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.color = .white
        
        return indicator
    }()
    
    init(viewModel: Photo) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(image)
        addSubview(activity)
        
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activity.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth, .flexibleHeight]
    }
    
}
