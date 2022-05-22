//
//  CollectionsModel.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

struct SearchCollections: Codable {
    var total: Int = 0
    var totalPages: Int = 0
    var results: [Collection] = []
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

// MARK: - Result
struct Collection: Codable {
    let id: String?
    let title: String
    let publishedAt, lastCollectedAt, updatedAt: String?
    let featured: Bool
    let totalPhotos: Int
    let resultPrivate: Bool
    let shareKey: String
    let coverPhoto: CoverPhoto
    let user: ResultUser
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

// MARK: - CoverPhoto
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

// MARK: - CoverPhotoLinks
struct CoverPhotoLinks: Codable {
    let linksSelf: String
    let html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}

// MARK: - CoverPhotoUser
struct CoverPhotoUser: Codable {
    let id, username, name, firstName: String?
    let lastName, instagramUsername, twitterUsername: String?
    let portfolioURL: String?
    let profileImage: ProfileImage
    let links: UserLinks

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case firstName = "first_name"
        case lastName = "last_name"
        case instagramUsername = "instagram_username"
        case twitterUsername = "twitter_username"
        case portfolioURL = "portfolio_url"
        case profileImage = "profile_image"
        case links
    }
}

// MARK: - ResultUser
struct ResultUser: Codable {
    let id, username, name: String?
    let bio: String?
    let profileImage: ProfileImage
    let links: UserLinks

    enum CodingKeys: String, CodingKey {
        case id, username, name
        case bio
        case profileImage = "profile_image"
        case links
    }
}
