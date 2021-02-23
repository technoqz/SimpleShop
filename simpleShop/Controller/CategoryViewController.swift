//
//  DetailCollectionViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

class CategoryViewController: BaseViewController, CustomNavBarDelegate, UICollectionViewDataSource, CategoryViewCellDelegate{

    var foods: [Food]!
    var filteredFoods = [Food]()
    var isSearching = false
    var customNavBar: CustomNavBarView?
    
    override var addHeightCard:Bool { true }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        customNavBar = CustomNavBarView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width  , height: 40),
                                        delegate:self,
                                        navigationController: navigationController,
                                        navigationItem: navigationItem,
                                        title: foods.first?.categoryName ?? "Меню",
                                        showInfoButton: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customNavBar?.updateBadge(animated: false)
    }
    
    // MARK: CategoryViewCellDelegate
    func addCartButtonPressed(food: Food) {
        Cart.addCart(cartItem: CartItem(food: food))
        customNavBar?.updateBadge()
    }
    
    // MARK: CustomNavBarDelegate
    func searchButtonPressed(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        if textSearched.count > 0{
            isSearching = true
            self.filteredFoods = foods.filter { $0.name.localizedCaseInsensitiveContains(textSearched) }
        }else{
            isSearching = false
            self.filteredFoods = [Food]()
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return isSearching ? filteredFoods.count : foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.identifier, for: indexPath) as! CategoryViewCell
        
        let tempFoods = isSearching ? filteredFoods : foods
        
        cell.configure(food: tempFoods![indexPath.row])
        cell.delegate = self
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! DetailViewController
            let cell = sender as! CategoryViewCell
            
            // send selected item
            destVC.food = foods.filter{ $0.id == cell.food.id}.first
        }
    }
}
