//
//  PhotosEndPoint.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

enum PhotosApi {
    case newPhotos(req: PhotoRequest)
}

extension PhotosApi: EndPointType {
    
    var environmentBaseURL : String {
        switch environment {
            case .production: return "https://api.unsplash.com"
            case .qa: return "https://api.unsplash.com"
            case .staging: return "https://api.unsplash.com"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .newPhotos:
            return "/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case let .newPhotos(request):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page" : "\(request.page)",
                                                      "per_page" : "\(request.perPage)",
                                                      "orderBy" : request.orderBy]
            )
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization" : "Client-ID MhaQ5jc0XWoSxCMS54Q5uEH2h3WcYOFfs13pAGgQPKQ"]
    }
}
