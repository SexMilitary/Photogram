//
//  CoverPhoto.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

struct CoverPhoto: Codable {
    let id: String?
    let createdAt: String
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let coverPhotoDescription: String?
    let user: CoverPhotoUser
    let urls: Urls
    let links: CoverPhotoLinks

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case coverPhotoDescription = "description"
        case user, urls, links
    }
}
