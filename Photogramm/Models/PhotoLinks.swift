//
//  PhotoLinks.swift
//  Photogramm
//
//  Created by Максим Чикинов on 14.04.2022.
//

import Foundation

struct PhotoLinks: Codable {
    let linksSelf, html, download: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
    }
}
