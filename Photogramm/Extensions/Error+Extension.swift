//
//  Error+Extension.swift
//  Photogramm
//
//  Created by User on 20.04.2022.
//

import Foundation

extension Error {
    var localizedTitle: String {
        return (self as NSError).localizedFailureReason ?? "Ошибка"
    }
    
    var code: Int {
        return (self as NSError).code
    }
    
    var errorURL: String? {
        let nsError = self as NSError
        let urlObject = nsError.userInfo[NSURLErrorKey]
        
        if let stringUrl = urlObject as? String {
            return stringUrl
        }
        
        if let url = urlObject as? URL {
            return url.absoluteString
        }
        
        return nil
    }
}
