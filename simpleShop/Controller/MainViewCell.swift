//
//  MainViewCell.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 17.02.2021.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    static let identifier = "MainViewCell"
    
    var categoryId = 0
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel?

    func configure(category: Category){
        self.cornerRadius()
        nameLabel?.text = category.name
        categoryId = category.id
        
        imageView.image = UIImage(named: "\(categoryId).jpg")
    }
}
