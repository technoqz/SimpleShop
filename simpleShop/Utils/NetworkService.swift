//
//  NetworkService.swift
//  simpleShop
//
//  Created by Sergey Ipatov on 10.02.2021.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() { }
    
    func getData(completion: @escaping  ([Category]?,String?) -> () ) {
        guard let queryUrl = URL(string: "https://bitrixdev.ru/simple_shop/api/") else {  completion(nil, "url error?"); return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: queryUrl) { (data, response, error) in
            guard error == nil else {  completion(nil, "dataTask error?"); return  }
            guard let safeData = data else { completion(nil, "safeData error?"); return  }
            
            let decoder = JSONDecoder()
            
            do{
                let results = try decoder.decode([Category].self, from: safeData)
                completion(results,nil)
            } catch{
                print(error)
                completion(nil, "decoder error? \(error)"); return
            }
        }
        task.resume()
    }
}


