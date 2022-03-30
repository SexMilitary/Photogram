//
//  PhotoServices.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

final class PhotoServices {
    
    func getPhotos(request: PhotoRequest, completion: @escaping (Result<Photos, Error>) -> Void) {
        let networkManager = NetworkManager<PhotosApi, Photos>()
        networkManager.getRequest(endPoint: .newPhotos(req: request), completion: completion)
    }
    
}
