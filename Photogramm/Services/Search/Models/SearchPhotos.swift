//
//  SearchPhotos.swift
//  Photogramm
//
//  Created by Максим Чикинов on 28.03.2022.
//

import Foundation

// MARK: - Welcome
struct SearchPhotos: Codable {
    var total: Int = 0
    var totalPages: Int = 0
    var results: [Photo] = []
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
    
    mutating func clear() {
        total = 0
        totalPages = 0
        results.removeAll()
    }
    
    var isEmpty: Bool {
        total == 0 && totalPages == 0 && results.isEmpty
    }
}
