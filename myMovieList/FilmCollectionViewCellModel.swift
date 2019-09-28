//
//  FilmCollectionViewCellModel.swift
//  myMovieList
//
//  Created by Yagiz Ugur on 19.07.2019.
//  Copyright © 2019 Yagimutsu. All rights reserved.
//

import UIKit

var VC = ViewController()

class FilmCollectionViewCellModel: UICollectionViewCell {
    
    var filmPosterCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FilmPosterCollectionViewCellModel.self, forCellWithReuseIdentifier: "postercell")
        //cv.tag = 3
        cv.backgroundColor = .black
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //cv.autoresizesSubviews = true
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: (UIScreen.main.bounds.width-posterWidth*2)/3, bottom: 10, right: (UIScreen.main.bounds.width-posterWidth*2)/3)
        
        return cv
    }()
    
    func reloadFilmCollectionView(){
        filmPosterCollectionView.reloadData()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(filmPosterCollectionView)
        
        filmPosterCollectionView.dataSource = collectionViewArr[1].dataSource
        filmPosterCollectionView.delegate = collectionViewArr[1].delegate
        
       // collectionViewArr.append(filmPosterCollectionView)
        
        filmPosterCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        filmPosterCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        filmPosterCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        filmPosterCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
       
        //print(filmPosterCollectionView.frame.width,filmPosterCollectionView.frame.height)
        //VC.showActivityIndicator()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
