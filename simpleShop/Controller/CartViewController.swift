//
//  CartViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 15.02.2021.
//

import UIKit

class CartViewController: UITableViewController, CartViewCellDelegate, CartViewOrderCellDelegate{

    var cartItemArray : [CartItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nibs for last table row
        tableView.register(CartViewOrderCell.nib(), forCellReuseIdentifier: CartViewOrderCell.identifier)
        tableView.register(CartViewNoneCell.nib() , forCellReuseIdentifier: CartViewNoneCell.identifier)
        
        // load data for cart page
        self.cartItemArray = Cart.cartItemArray
        
        // set title navbar
        let titleLabel = UILabel()
        titleLabel.font = titleLabel.font.withSize(25)
        titleLabel.text = "Корзина"
        navigationItem.titleView = titleLabel
        
        let backButton = UIBarButtonItem()
        backButton.title = "Назад"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.normalNavigationBar()
    }
    
    // MARK: CartViewCellDelegate
    func updateCartArray(cartItemArray: [CartItem]) {
        self.cartItemArray = cartItemArray
        tableView.reloadData()
    }
    
    // MARK: CartViewOrderCellDelegate
    func callSegue() {
        performSegue(withIdentifier: "toConfirmOrder", sender: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItemArray.count+1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // setup for last row
        if indexPath.row == cartItemArray.count{
            if cartItemArray.count > 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CartViewOrderCell.identifier, for: indexPath) as! CartViewOrderCell
                
                cell.priceLabel.text = String(Cart.getSumCart()) + " ₽"
                cell.configure(delegate: self)
                
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: CartViewNoneCell.identifier, for: indexPath) as! CartViewNoneCell

                return cell
            }
            
        }else{
            // default cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CartViewCell
            
            cell.configure(delegate: self, carItem: cartItemArray[indexPath.row])
            
            return cell
        }
     }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0;
    }
    
    //hide footer separation lines
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
