//
//  AppDetailController.swift
//  AppStore
//
//  Created by iosadmin on 28.6.2018.
//  Copyright © 2018 iosadmin. All rights reserved.
//

import UIKit

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        
        didSet {
            
            if app?.screenshots != nil {
                return
            }
            
            if let id = app?.id {
                NetworkService.instance.fetchDetailedApp(id: id, completion: { (response) in
                    self.app = response
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                })
            }
            
            
            navigationItem.title = app?.name
        }
    }
    
    private let headerId = "headerId"
    private let cellId = "cellId"
    private let descriptionCellId = "descriptionCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(ScreenshotCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: descriptionCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: descriptionCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ScreenshotCell
        
        cell.app = app
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 1 {
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            return CGSize(width: view.frame.width, height: rect.height + 30)
        }
        
        return CGSize(width: view.frame.width, height: 170)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.length)
        attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: range)
        
        
        if let desc = app?.description {
            attributedText.append(NSAttributedString(string: desc, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 11), NSAttributedStringKey.foregroundColor: UIColor.darkGray]))
        }
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
}

class AppDetailDescriptionCell: BaseCell {
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE DESCRIPTION"
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func setupViews() {
        addSubview(textView)
        addSubview(dividerLineView)
        
        //x, y, width, height
        textView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
        
        //x, y, width, height
        dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14).isActive = true
        dividerLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerLineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            
            if let name = app?.name {
                nameLabel.text = name
            }
            
            if let price = app?.price {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.cyan
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func setupViews(){
        super.setupViews()
        
        addSubview(imageView)
        addSubview(segmentControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)


        //x, y, width, height
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 14).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        //x, y, width, height
        segmentControl.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 40).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -40).isActive = true
        segmentControl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 14).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        //x, y, width, height
        nameLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14).isActive = true
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20)
        
        //x, y, width, height
        buyButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        buyButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        buyButton.bottomAnchor.constraint(equalTo: segmentControl.topAnchor, constant: -14).isActive = true
        buyButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -14).isActive = true
        
        //x, y, width, height
        dividerLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        dividerLineView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        dividerLineView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        dividerLineView.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 14).isActive = true
    }
  
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
