//
//  DetailViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

class DetailViewController: UIViewController, CustomNavBarDelegate {
    
    var food : Food!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    var customNavBar: CustomNavBarView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavBar = CustomNavBarView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width  , height: 40),
                                        delegate:self,
                                        navigationController: navigationController,
                                        navigationItem: navigationItem,
                                        title: "",
                                        showInfoButton: false,
                                        showSearchButton: false)

        nameLabel.text = food.name
        
        if let description = food.description{
                descriptionLabel.text = "Состав: \(description)"
        }
        
        priceLabel.text = String(food.price) + " ₽"
        
        if let weight = food.weight {
            weightLabel.text = weight + "гр."
        }
        
        if let imgThumb = URL(string: food.imgthumb){
            imageView.load(url: imgThumb)
        }
        
        addCartButton?.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customNavBar?.updateBadge(animated: false)
        self.navigationController?.normalNavigationBar()
    }
    
    @IBAction func addCartPressed(_ sender: UIButton) {

        Cart.addCart(cartItem: CartItem(food: food))
        customNavBar?.updateBadge()
    }
}
