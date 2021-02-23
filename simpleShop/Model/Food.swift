//
//  Food.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 15.02.2021.
//

import Foundation

struct Food: Decodable,Encodable{
    var id: Int
    let name: String
    let weight: String?
    let price: Int
    let imgthumb: String
    let imgfull: String
    let categoryId: Int
    let categoryName: String
    let description: String?
    let url: String?
}
