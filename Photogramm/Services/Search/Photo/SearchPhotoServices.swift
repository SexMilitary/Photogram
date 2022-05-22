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
    
    func searchCollections(request: SearchCollectionsRequest, completion: @escaping (Result<SearchCollections, Error>) -> Void) {
        let networkManager = NetworkManager<SearchPhotosApi, SearchCollections>()
        networkManager.getRequest(endPoint: .searchCollections(req: request), completion: completion)
    }
}
