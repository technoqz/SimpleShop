//
//  Category.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 11.02.2021.
//

import Foundation

struct Category: Decodable{
    let id: Int
    let name: String
    let foods: [Food]
    let description: String?
    let imgthumb: String?
}


