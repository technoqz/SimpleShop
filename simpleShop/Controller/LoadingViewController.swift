//
//  LoadingViewController.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 17.02.2021.
//

import UIKit

class LoadingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.transparentNavigationBar()
        
        Categories.getCategories{ categories, error in
            
            guard error == nil else { Alert.show(vc: self, title: "Error", text: error!); return }
            
            if let categories = categories{
                DispatchQueue.main.async {
                     
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let mainVC = storyBoard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                    mainVC.categories = categories
                    
                    self.navigationController?.pushViewController(mainVC, animated: true)
                }
            }
        }
    }
}
