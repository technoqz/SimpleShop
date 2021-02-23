//
//  CartViewOrderCell.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 16.02.2021.
//

import UIKit

protocol CartViewOrderCellDelegate: class{
    func callSegue()
}

class CartViewOrderCell: UITableViewCell {

    static let identifier = "CartViewOrderCell"
    weak var delegate: CartViewOrderCellDelegate?
    
    static func nib() -> UINib {
        return UINib(nibName: "CartViewOrderCell", bundle: nil)
    }
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var orderButton: UIButton!
    
    func configure(delegate: CartViewOrderCellDelegate){
        self.delegate = delegate
        orderButton.backgroundColor = UIColor.systemGreen
        orderButton.layer.cornerRadius = 25
    }
    
    @IBAction func orderButtonPressed(_ sender: UIButton) {
        delegate?.callSegue()
    }
    
}
