//
//  SearchViewControllerModel.swift
//  Photogramm
//
//  Created by Максим Чикинов on 21.05.2022.
//

import UIKit

struct SearchViewControllerModel: PageControllersProtocol {
    var viewController: PageableController
    var number: Int
    var lastSearchText: String = ""
    var initialPage: Int = 0
}
