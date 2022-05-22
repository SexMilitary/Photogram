//
//  SearchCollectionsRequest.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

struct SearchCollectionsRequest {
    let query: String
    let page: Int
    let perPage: Int = 10
}
