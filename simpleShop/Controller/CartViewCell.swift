//
//  CartTableViewCell.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 15.02.2021.
//

import UIKit

protocol CartViewCellDelegate: class{
    func updateCartArray(cartItemArray: [CartItem])
}

class CartViewCell: UITableViewCell {

    static let identifier = "CartViewCell"
    
    var cartItem: CartItem!
    weak var delegate: CartViewCellDelegate?

    @IBOutlet weak var uiImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
        

    func configure(delegate: CartViewCellDelegate, carItem: CartItem) {
        
        self.cartItem = carItem
        self.delegate = delegate
        nameLabel.text = carItem.food.name
        countLabel.text = String(carItem.itemsCount) + " шт"
        priceLabel.text = String(carItem.food.price) + " ₽"
        uiImageView.load(url: URL(string: carItem.food.imgthumb)!)
        stepper.value = Double( carItem.itemsCount)
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        Cart.setCount(cartItem: cartItem, count: Int(sender.value))

        delegate?.updateCartArray(cartItemArray: Cart.cartItemArray)
    }
}
