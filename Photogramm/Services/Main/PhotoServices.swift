//
//  PhotoServices.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

final class PhotoServices {
    
    func getPhotos(request: PhotoRequest, completion: @escaping (Result<PhotoResponce, Error>) -> Void) {
        let networkManager = NetworkManager<PhotosApi, PhotoResponce>()
        networkManager.getRequest(endPoint: .newPhotos(req: request), completion: completion)
    }
    
}
