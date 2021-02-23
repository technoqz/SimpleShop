//
//  MainCollectionViewCell.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

protocol CategoryViewCellDelegate{
    func addCartButtonPressed(food: Food)
}

class CategoryViewCell: UICollectionViewCell {
    
    static let identifier = "CategoryViewCell"
    
    var food: Food!
    var delegate: CategoryViewCellDelegate!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var weightLabel: UILabel!
   
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(food: Food){

        self.cornerRadius()
                
        self.food = food
        nameLabel?.text = food.name.trunc(length: 33)

        priceLabel.text = String( food.price ) + " ₽"

        if let weight = food.weight  {
            weightLabel.text = weight  + " гр."
        }

        addCartButton?.layer.cornerRadius = 5
        
        if let imgThumbUrl = URL(string: food.imgthumb){
            imageView?.load(url: imgThumbUrl)
        }
    }
    
    @IBAction func addCartPressed(_ sender: UIButton) {
        delegate.addCartButtonPressed(food: self.food)
    }
}
