//
//  UserLinks.swift
//  Photogramm
//
//  Created by Максим Чикинов on 14.04.2022.
//

import Foundation

struct UserLinks: Codable {
    let linksSelf, html, photos, likes: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, photos, likes
    }
}
