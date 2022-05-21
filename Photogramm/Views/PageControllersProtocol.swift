//
//  PageControllersProtocol.swift
//  Photogramm
//
//  Created by Максим Чикинов on 21.05.2022.
//

import UIKit

protocol PageControllersProtocol {
    var viewController: PageableController { get set }
    var number: Int { get set }
    var lastSearchText: String? { get set }
}

protocol PageableController: UIViewController {
    var number: Int { get set }
}
