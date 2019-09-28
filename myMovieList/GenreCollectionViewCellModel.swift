//
//  GenreCollectionViewCellModel.swift
//  myMovieList
//
//  Created by Yagiz Ugur on 19.07.2019.
//  Copyright © 2019 Yagimutsu. All rights reserved.
//

import UIKit

var isLoaded = false



class GenreCollectionViewCellModel: UICollectionViewCell {
    
    var genreLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/9, height: UIScreen.main.bounds.width/9 ))
        
        label.backgroundColor = .black
        label.layer.cornerRadius = 5
        label.textAlignment = .center
        label.textColor = .white
        //label.font = UIFont(name: "SFProDisplay-Medium", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 2
        
        //Shadow
        label.layer.shadowOffset = CGSize(width: 5,height: 5)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.53
        label.layer.shadowRadius = 5
        
        return label
    }()
    
    var genreButton: UIButton = {
        var button = UIButton()
        
        button.backgroundColor = .black
        button.layer.cornerRadius = 5
        button.titleLabel?.textColor = .white
        button.tintColor = .white
        //label.font = UIFont(name: "SFProDisplay-Medium", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        
        //Shadow
        button.layer.shadowOffset = CGSize(width: 5,height: 5)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.53
        button.layer.shadowRadius = 5
        
        return button
    }()
    
    
    override var isSelected: Bool {
        didSet {
            
            //genreLabel.layer.borderWidth = 3.0
            //genreLabel.frame.size = isSelected ? CGSize(width:  UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/9) : CGSize(width:  UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.width/10)
            genreLabel.layer.borderColor = isSelected ? UIColor.red.cgColor : UIColor.white.cgColor
            genreLabel.textColor = isSelected ? UIColor.red : UIColor.white
            
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(genreLabel)
       
        genreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        genreLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        genreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
 
        if !isLoaded {
            collectionViewArr[0].selectItem(at: [0,0], animated: false, scrollPosition: [.centeredHorizontally,.centeredVertically])
            //collectionViewArr[0].reloadData()
            isLoaded = true
            
            
        }
        //print(currentCategory)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}



