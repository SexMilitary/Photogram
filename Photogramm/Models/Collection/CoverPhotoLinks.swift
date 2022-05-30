//
//  CoverPhotoLinks.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

struct CoverPhotoLinks: Codable {
    let linksSelf: String
    let html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}
