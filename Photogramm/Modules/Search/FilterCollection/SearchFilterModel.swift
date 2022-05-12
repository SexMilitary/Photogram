//
//  SearchFilterModel.swift
//  Photogramm
//
//  Created by User on 12.05.2022.
//

import Foundation

class SearchFilters {
    var filters: [SearchFilter] = SearchFilter.getFilters
}

class SearchFilter {
    enum Filter: String, CaseIterable {
        case photos
        case collections
        case users
        case wallpapers
        case avatars
        
        var title: String {
            self.rawValue.capitalized
        }
        
        var isSelected: Bool {
            self == .photos
        }
    }
    
    static let allCases = Filter.allCases
    
    static var getFilters: [SearchFilter] {
        return allCases.map({ SearchFilter(type: $0, title:  $0.title, isSelect: $0.isSelected) })
    }
    
    var type: Filter = .photos
    var title = ""
    var isSelect = false
    
    init(type: Filter, title: String, isSelect: Bool) {
        self.type = type
        self.title = title
        self.isSelect = isSelect
    }
}