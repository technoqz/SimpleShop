//
//  DetailCollectionViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

class CategoryViewController: BaseViewController, CustomNavBarDelegate, UICollectionViewDataSource{

    var foods: [Food]!
    var filteredFoods = [Food]()
    var isSearching = false
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: CustomNavBarDelegate
    func search(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        
        if textSearched.count > 0{
            isSearching = true
            self.filteredFoods = foods.filter { $0.name.contains(textSearched) }
        }else{
            isSearching = false
            self.filteredFoods = [Food]()
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return isSearching ? filteredFoods.count : foods.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        let tempFoods = isSearching ? filteredFoods : foods
        
        cell.nameLabel?.text = tempFoods![indexPath.row].name
        cell.id = tempFoods![indexPath.row].id
        
        cell.imageView?.load(url: URL(string: tempFoods![indexPath.row].imgthumb)!)
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! DetailViewController
            
            let cell = sender as! CollectionViewCell
            
            destVC.item = foods.filter{ $0.id == cell.id }.first
            
        }
    }

}




