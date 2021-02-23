//
//  MainCollectionViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

class MainViewController:  BaseViewController, CustomNavBarDelegate, UICollectionViewDataSource {

    var categories = [Category]()
    var filteredCategories = [Category]()
    var isSearching = false
    var customNavBar: CustomNavBarView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customNavBar = CustomNavBarView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width  , height: 40),
                                        delegate:self,
                                        navigationController: navigationController,
                                        navigationItem: navigationItem,
                                        title: "Меню")
                
        Cart.loadFromDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        customNavBar?.updateBadge(animated: false)
    }
    
    // MARK: CustomNavBarDelegate
   
    func searchButtonPressed(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        if textSearched.count > 0{
            isSearching = true
            self.filteredCategories = categories.filter { $0.name.localizedCaseInsensitiveContains(textSearched) }
        }else{
            isSearching = false
            self.filteredCategories = [Category]()
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredCategories.count : categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainViewCell.identifier, for: indexPath) as! MainViewCell
        
        let tempCats = isSearching ? filteredCategories : categories

        cell.configure(category: tempCats[indexPath.row])
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategories" {
            let destVC = segue.destination as! CategoryViewController
            
            let cell = sender as! MainViewCell
            
            //send selected foods
            destVC.foods = categories.filter{ $0.id == cell.categoryId }.first?.foods

        }
    }
    
    // unwind with alert after confirm order
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        Alert.show(vc: self, title: "Заказ отправлен", text: "Спасибо за заказ. Мы свяжемся с вами в самое ближайшее время.")
    }
}
