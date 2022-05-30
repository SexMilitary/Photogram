//
//  User.swift
//  Photogramm
//
//  Created by Максим Чикинов on 14.04.2022.
//

import Foundation

struct User: Codable {
    let id, username, name: String
    let links: UserLinks
    let profileImage: ProfileImage
    let location: String?
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username, name, links, location
        case profileImage = "profile_image"
        case bio
    }
    
    var formatedLocation: String? {
        guard let location = location, location.count > 10 else { return location }
        let firstStr = location.components(separatedBy: ",").first
        return firstStr?.capitalized
    }
}
