//
//  MainCollectionViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

class MainViewController:  BaseViewController, CustomNavBarDelegate, UICollectionViewDataSource {

    var categories = [Category]()
    var isSearching = false
    var filteredCategories = [Category]()
    
    override var titleText: String { "Меню333" }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Categories.getCategories{ categories in
            self.categories = categories
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: CustomNavBarDelegate
    func search(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        if textSearched.count > 0{
            isSearching = true
            self.filteredCategories = categories.filter { $0.name.contains(textSearched) }
        }else{
            isSearching = false
            self.filteredCategories = [Category]()
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredCategories.count : categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let tempCats = isSearching ? filteredCategories : categories
        
        cell.nameLabel?.text = tempCats[indexPath.row].name
        cell.id = tempCats[indexPath.row].id
    
        if let imgUrl = tempCats[indexPath.row].foods.first?.imgthumb{
            cell.imageView.load(url: URL(string: imgUrl)!)
        }
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategories" {
            let destVC = segue.destination as! CategoryCollectionViewController
            
            let cell = sender as! CollectionViewCell
            
            destVC.foods = categories.filter{ $0.id == cell.id }.first?.foods

        }
    }
}
