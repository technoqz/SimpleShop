//
//  ExpandableView.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 08.02.2021.
//

import UIKit

@objc
protocol CustomNavBarDelegate: class{
    @objc optional func searchButtonPressed(_ searchBar: UISearchBar, textDidChange textSearched: String)
}

enum typeBageAction {
    case add
    case subtract
    case clear
}

class CustomNavBarView: UIView, UISearchBarDelegate {
    
    weak var delegate: CustomNavBarDelegate?
    weak var navigationController: UINavigationController?
    weak var navigationItem:UINavigationItem?
    
    var uiBarSearchButton : UIBarButtonItem!
    var uiBarCartButton : BadgeBarButtonView!
    var uiBarInfoButton : UIBarButtonItem!
    var searchBar = UISearchBar()
    var barIcon: UIBarButtonItem.SystemItem = .search
    
    // title settings
    var titleLabel = UILabel()
    var titleFontSize : CGFloat = 25
    var titleText = ""
    
    // state params settings
    var isSearchOpen: Bool = false
    var showInfoButton: Bool = true
    var showSearchButton: Bool = true
    
    init(frame: CGRect,delegate:CustomNavBarDelegate, navigationController: UINavigationController?, navigationItem:UINavigationItem, title: String, showInfoButton : Bool = true, showSearchButton : Bool = true) {
        super.init(frame: frame)
        self.navigationController = navigationController
        self.navigationItem = navigationItem
        self.titleText = title
        self.showInfoButton = showInfoButton
        self.showSearchButton = showSearchButton
        self.delegate = delegate
        
        self.searchBar.delegate = self
        
        // create nav buttons
        setupButtons()
        setupBadge()
    }
    
    func setupButtons(){
        translatesAutoresizingMaskIntoConstraints = false
        
        //setup events
        uiBarSearchButton = UIBarButtonItem(barButtonSystemItem: .search , target: self, action: #selector(toggleSearch))
        uiBarInfoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle") , style: .plain , target: self, action: #selector(infoButtonPressed))
        
        titleLabel.font = titleLabel.font.withSize(titleFontSize)
        titleLabel.text = titleText
        addSubview(titleLabel)
        navigationItem?.titleView = titleLabel
    }
    
    func setupBadge(){
        let customCartButton = UIButton(type: UIButton.ButtonType.custom)
        customCartButton.frame = CGRect(x: 0, y: 0, width: 35.0, height: 35.0)
        
        customCartButton.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
        
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 23)
        let cartImage = UIImage(systemName: "cart", withConfiguration: iconConfig)
        
        customCartButton.setImage(cartImage, for: .normal)
        
        uiBarCartButton = BadgeBarButtonView()
        uiBarCartButton.setup(customButton: customCartButton)

        uiBarCartButton.badgeOriginX = 20.0
        uiBarCartButton.badgeOriginY = 0
        
        navigationItem?.leftBarButtonItem = showInfoButton ? uiBarInfoButton : nil
        navigationItem?.rightBarButtonItems =  showSearchButton ? [uiBarCartButton,uiBarSearchButton] : [uiBarCartButton]
    }
    
    func updateBadge(animated : Bool = true){
        
        if !animated{ uiBarCartButton.shouldAnimateBadge = false }
        let cartCount = Cart.cartItemArray.count
        uiBarCartButton?.badgeValue = String(cartCount)
        let searchButton = UIBarButtonItem(barButtonSystemItem: barIcon , target: self, action: #selector(toggleSearch))
        navigationItem?.rightBarButtonItems =  showSearchButton ? [uiBarCartButton,searchButton] : [uiBarCartButton]
        if !animated{ uiBarCartButton.shouldAnimateBadge = true }
    }

    @objc func toggleSearch() {
        
        if !isSearchOpen {
            navigationItem?.titleView = searchBar
            searchBar.becomeFirstResponder()
            barIcon = .close
        }else{
            navigationItem?.titleView = titleLabel

            if let strCount = searchBar.searchTextField.text?.count{
                if strCount > 0{
                    self.searchBar.text = ""
                    self.searchBar(searchBar, textDidChange: "")
                }
            }
            barIcon = .search
        }

        let searchButton = UIBarButtonItem(barButtonSystemItem: barIcon , target: self, action: #selector(toggleSearch))
        navigationItem?.rightBarButtonItems = [uiBarCartButton,searchButton]
        isSearchOpen = !isSearchOpen
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String){
        delegate?.searchButtonPressed?(searchBar, textDidChange: textSearched)
    }
    
    @objc func infoButtonPressed(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let infoVC = storyBoard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        
        navigationController?.pushViewController(infoVC, animated: true)
    }
    
    @objc func cartButtonPressed() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let cartVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
