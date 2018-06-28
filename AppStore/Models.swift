//
//  Models.swift
//  AppStore
//
//  Created by iosadmin on 28.6.2018.
//  Copyright © 2018 iosadmin. All rights reserved.
//

import Foundation

struct ServerResponse: Decodable {
    var bannerCategory: AppCategory
    var categories: [AppCategory]
}

struct AppCategory: Decodable {
    var name: String?
    var apps: [App]?
    var type: String?
    
    static func sampleAppCategories() -> [AppCategory] {
        var bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var apps = [App]()
        
        //logic
        var frozenApp = App()
        frozenApp.name = "Disnet Build It: Frozen"
        frozenApp.imageName = "frozen"
        frozenApp.category = "Entertainment"
        frozenApp.price = 3.99
        apps.append(frozenApp)
        
        bestNewAppsCategory.apps = apps
        
        var bestNewGamesCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Games"
        
        var bestNewsGamesApps = [App]()
        var telepaintApp = App()
        telepaintApp.name = "Telepaint"
        telepaintApp.imageName = "telepaint"
        telepaintApp.category = "Games"
        telepaintApp.price = 2.99
        
        bestNewsGamesApps.append(telepaintApp)
        
        bestNewGamesCategory.apps = bestNewsGamesApps
        
        
        return [bestNewAppsCategory, bestNewGamesCategory]
    }
}

struct App: Decodable {
    var id: Int?
    var name: String?
    var imageName: String?
    var category: String?
    var price: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case imageName = "ImageName"
        case category = "Category"
        case price = "Price"
    }
}
