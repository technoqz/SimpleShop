//
//  Cart.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 15.02.2021.
//

import Foundation

class CartItem: Decodable,Encodable{
    var itemsCount: Int
    let food: Food
    
    init(food: Food, itemsCount: Int = 1) {
        self.itemsCount = itemsCount
        self.food = food
    }
}

class Cart{
    
    static var cartItemArray = [CartItem]()
        
    private init() { }
    
    static func save(){
        let jsonEncoder = JSONEncoder()
        
        do {
            let jsonData = try jsonEncoder.encode(Cart.cartItemArray)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            
            if let jsonSafe = json {
                UserDefaults.standard.set(jsonSafe, forKey: "CartJson")
            }
        } catch {
            print(error)
        }
    }
    
    static func getSumCart() -> Int{
        var sum = 0.0
        
        for el in Cart.cartItemArray {
            sum += ( Double(el.itemsCount) *  Double(el.food.price) )
        }
        
        return Int(sum)
    }
    
    static func loadFromDefaults(){
        
        let cartJsonDefaults = UserDefaults.standard.string(forKey: "CartJson")
        
        guard let cartJson = cartJsonDefaults else { return }
        guard let cartData = cartJson.data(using: .utf8) else { return }
        
        let jsonDecoder = JSONDecoder()
        do {
            Cart.cartItemArray = try jsonDecoder.decode([CartItem].self, from: cartData)
            save()
        } catch {
            print(error)
        }
    }
    
    static func setCount(cartItem: CartItem, count: Int){
        if let existCartItem = Cart.cartItemArray.first(where: { $0.food.id == cartItem.food.id }) {
            if count < 1 {
                Cart.cartItemArray.removeAll { $0.food.id == cartItem.food.id}
            }else{
                existCartItem.itemsCount = count
            }
        }
        save()
    }

    static func addCart(cartItem: CartItem) {
        
        if let existCartItem = Cart.cartItemArray.first(where: { $0.food.id == cartItem.food.id }) {
            existCartItem.itemsCount += 1
        }else{
            Cart.cartItemArray.append(cartItem)
        }
        
        save()
    }
    
    static func delCart(cartItem: CartItem){
        if let existCartItem = Cart.cartItemArray.first(where: { $0.food.id == cartItem.food.id }) {
            if existCartItem.itemsCount < 2{
                Cart.cartItemArray.removeAll { $0.food.id == cartItem.food.id}
            }else{
                existCartItem.itemsCount -= 1
            }
        }
        save()
    }
    
    static func clearCart(){
        Cart.cartItemArray.removeAll()
        save()
    }
}



