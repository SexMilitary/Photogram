//
//  CoverPhotoUser.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

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
