//
//  shopModel.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import Foundation

class Categories {
    static var categories = [Category]()
    
    static func getCategories(_ completion: @escaping  ( [Category]? , String?) -> () ) {
        
        let net = NetworkService.shared
        net.getData { (categories, error) in
            if error == nil {
                if let safeCategories = categories {
                    self.categories = safeCategories
                    completion(safeCategories, nil)
                }
            }else{
                completion(nil, "Ошибка получения данных. Проверьте доступ к сети.")
            }
        }
    }
}
