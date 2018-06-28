//
//  ViewController.swift
//  AppStore
//
//  Created by iosadmin on 28.6.2018.
//  Copyright © 2018 iosadmin. All rights reserved.
//

import UIKit

class FeaturedAppController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    private let largeCellId = "largeCellId"
    private let headerId = "headerId"
    
    var appCategories: [AppCategory]?
    var bannerCategory: AppCategory?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Featured Apps"
        
        NetworkService.instance.fetchFeatureApps(completion: { (response) in
            self.appCategories = response.categories
            self.bannerCategory = response.bannerCategory
            
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        })
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(CategoryCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(LargeCategoryCell.self, forCellWithReuseIdentifier: largeCellId)
        
        collectionView?.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    func showAppDetailForApp(app: App) {
        let appDetailController = AppDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        appDetailController.app = app
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count =  appCategories?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! LargeCategoryCell
            cell.appCategory = appCategories?[indexPath.item]
            cell.featuredAppsController = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CategoryCell
        cell.appCategory = appCategories?[indexPath.item]
        cell.featuredAppsController = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 2 {
            return CGSize(width: view.frame.width, height: 160)
        }
        return CGSize(width: view.frame.width, height: 230)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        header.appCategory = bannerCategory
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

class LargeCategoryCell: CategoryCell {
    
    private let largeCellId = "largeCellId"
    
    override func setupViews() {
        super.setupViews()
        appCollectionView.register(LargeAppCell.self, forCellWithReuseIdentifier: largeCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height - 32)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: largeCellId, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    private class LargeAppCell: AppCell {
        
        override func setupViews() {
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            //x, y, width, height
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
    }
}

class Header: CategoryCell {
    
    let cellId = "bannerCellId"
    
    override func setupViews() {
        appCollectionView.dataSource = self
        appCollectionView.delegate = self
        appCollectionView.register(BannerCell.self, forCellWithReuseIdentifier: cellId)
        
        addSubview(appCollectionView)
        
        //x, y, width, height
        appCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        appCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        appCollectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        appCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: frame.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppCell
        cell.app = appCategory?.apps?[indexPath.item]
        return cell
    }
    
    private class BannerCell: AppCell {
        
        override func setupViews() {
            addSubview(imageView)
            imageView.layer.cornerRadius = 0
            imageView.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            imageView.layer.borderWidth = 0.5
            imageView.translatesAutoresizingMaskIntoConstraints = false
            
            //x, y, width, height
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -14).isActive = true
            imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
    }
}

