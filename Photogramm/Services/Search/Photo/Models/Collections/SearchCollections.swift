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
