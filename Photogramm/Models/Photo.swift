//
//  Photo.swift
//  Photogramm
//
//  Created by Максим Чикинов on 14.04.2022.
//

import Foundation

// MARK: - Photo
struct Photo: Codable {
    let id: String
    let createdAt: String
    let width, height: Int
    let color, blurHash: String?
    let likes: Int
    let likedByUser: Bool
    let photoDescription: String?
    let urls: Urls
    let links: PhotoLinks
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case photoDescription = "description"
        case urls, links
        case user
        case createdAt = "created_at"
    }
    
    var ratio: Double {
        Double(width) / Double(height)
    }
}
