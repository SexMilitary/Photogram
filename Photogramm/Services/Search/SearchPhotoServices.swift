//
//  SearchPhotoServices.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

final class SearchPhotoServices {
    
    func searchPhotos(request: SearchPhotoRequest, completion: @escaping (Result<SearchPhotos, Error>) -> Void) {
        let networkManager = NetworkManager<SearchPhotosApi, SearchPhotos>()
        networkManager.getRequest(endPoint: .searchPhoto(req: request), completion: completion)
    }
    
}
