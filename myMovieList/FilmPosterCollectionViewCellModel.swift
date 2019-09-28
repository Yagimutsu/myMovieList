//
//  FilmPosterCollectionViewCellModel.swift
//  myMovieList
//
//  Created by Yagiz Ugur on 26.07.2019.
//  Copyright © 2019 Yagimutsu. All rights reserved.
//

import UIKit

var posterWidth = CGFloat(250*1.375).pixelsToPoints()
var posterHeight = CGFloat(375*1.375).pixelsToPoints()

class FilmPosterCollectionViewCellModel: UICollectionViewCell {

    var poster: UIImageView = {
        
        var posterSelf = UIImageView()//frame: CGRect(x: 10, y: 10, width: posterWidth, height: (posterWidth/ratio)))

        return posterSelf
    }()
    
    var title: UILabel = {
        
        var label = UILabel()
        
        label.backgroundColor = UIColor(displayP3Red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        
        label.textAlignment = .center
        label.textColor = .white
        label.adjustsFontSizeToFitWidth = true
        //label.font = UIFont(name: "SFProDisplay-Medium", size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        //Shadow
        label.layer.shadowOffset = CGSize(width: 5,height: 5)
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.53
        label.layer.shadowRadius = 5
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(poster)
        
        poster.addSubview(title)
        poster.frame.size = CGSize(width: posterWidth, height: posterHeight)
        
        poster.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        poster.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        poster.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        poster.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
 
        title.topAnchor.constraint(equalTo: self.poster.topAnchor, constant: self.poster.bounds.height/1.2).isActive = true
        title.rightAnchor.constraint(equalTo: self.poster.rightAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: self.poster.leftAnchor).isActive = true
        title.bottomAnchor.constraint(equalTo: self.poster.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
