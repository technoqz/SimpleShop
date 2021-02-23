//
//  CartViewNoneCell.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 21.02.2021.
//

import UIKit

class CartViewNoneCell: UITableViewCell {

    static let identifier = "CartViewNoneCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "CartViewNoneCell", bundle: nil)
    }
}
