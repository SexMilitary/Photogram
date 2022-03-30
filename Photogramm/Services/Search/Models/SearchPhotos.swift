//
//  SearchPhotos.swift
//  Photogramm
//
//  Created by Максим Чикинов on 28.03.2022.
//

import Foundation

// MARK: - Welcome
struct SearchPhotos: Codable {
    let total: Int = 0
    let totalPages: Int = 0
    var results: [SearchPhoto] = []
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct SearchPhoto: Codable {
    let id: String
    let createdAt: String?
    let width, height: Int
    let color, blurHash: String
    let likes: Int
    let likedByUser: Bool
    let resultDescription: String?
    let altDescription: String?
    let user: User
    let urls: Urls
    let links: ResultLinks
    
    var ratio: Double {
        Double(width) / Double(height)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, color
        case blurHash = "blur_hash"
        case likes
        case likedByUser = "liked_by_user"
        case resultDescription = "description"
        case altDescription = "alt_description"
        case user
        case urls, links
    }
}

// MARK: - ResultLinks
struct ResultLinks: Codable {
    let linksSelf: String
    let html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}

// MARK: - ProfileImage
struct ProfileImage: Codable {
    let small, medium, large: String
}
