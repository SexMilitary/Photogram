//
//  Photos.swift
//  Photogramm
//
//  Created by Максим Чикинов on 13.03.2022.
//

import Foundation

typealias Photos = [Photo]

struct Photo: Decodable {
    let id: String
    let likes: Int
    let description: String?
    let urls: [String : String]
    let height: Int
    let width: Int
    
    var ratio: Double {
        Double(width) / Double(height)
    }
    
    var getThumbImageUrl: String? {
        get {
            urls["thumb"]
        }
    }
    
    var getSmallImageUrl: String? {
        get {
            urls["small"]
        }
    }
    
    var getMediumImageUrl: String? {
        get {
            urls["regular"]
        }
    }
    
    var getRawImageUrl: String? {
        get {
            urls["raw"]
        }
    }
    
    var getFullImageUrl: String? {
        get {
            urls["full"]
        }
    }
}
