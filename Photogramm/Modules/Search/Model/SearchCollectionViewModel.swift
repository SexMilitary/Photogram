//
//  SearchCollectionViewModel.swift
//  Photogramm
//
//  Created by Максим Чикинов on 22.05.2022.
//

import Foundation

enum SearchCollectionViewModel {
    case photo(model: SearchPhotos)
    case collection(model: SearchCollections)
}
