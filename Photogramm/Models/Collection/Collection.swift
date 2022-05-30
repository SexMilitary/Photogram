//
//  Collection.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

struct Collection: Codable {
    let id: String?
    let title: String
    let publishedAt, lastCollectedAt, updatedAt: String?
    let featured: Bool
    let totalPhotos: Int
    let resultPrivate: Bool
    let shareKey: String
    let coverPhoto: CoverPhoto
    let user: User
    let links: UserLinks

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case publishedAt = "published_at"
        case lastCollectedAt = "last_collected_at"
        case updatedAt = "updated_at"
        case featured
        case totalPhotos = "total_photos"
        case resultPrivate = "private"
        case shareKey = "share_key"
        case coverPhoto = "cover_photo"
        case user, links
    }
}
