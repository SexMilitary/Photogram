//
//  PhotosEndPoint.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

enum SearchPhotosApi {
    case searchPhoto(req: SearchPhotoRequest)
}

extension SearchPhotosApi: EndPointType {
    
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
        case .searchPhoto:
            return "/search/photos"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case let .searchPhoto(request):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["page" : "\(request.page)",
                                                      "query" : "\(request.query)"]
            )
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Authorization" : "Client-ID MhaQ5jc0XWoSxCMS54Q5uEH2h3WcYOFfs13pAGgQPKQ"]
    }
}
