//
//  NetworkService.swift
//  AppStore
//
//  Created by iosadmin on 28.6.2018.
//  Copyright © 2018 iosadmin. All rights reserved.
//

import Foundation

class NetworkService {
    static let instance = NetworkService()
    
    func fetchFeatureApps(completion: @escaping (ServerResponse) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let jsonDecoder = JSONDecoder()
                let serverResponse = try jsonDecoder.decode(ServerResponse.self, from: data)
                completion(serverResponse)
            } catch let err {
                print(err)
            }
            
            }.resume()
    }
    
    
    func fetchDetailedApp(id: Int, completion: @escaping (App) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) -> Void in
            if error != nil {
                print(error!)
                return
            }
            
            guard let data = data else {return}
            
            do {
                let jsonDecoder = JSONDecoder()
                let serverResponse = try jsonDecoder.decode(App.self, from: data)
                completion(serverResponse)
            } catch let err {
                print(err)
            }
            
            }.resume()
    }
}
