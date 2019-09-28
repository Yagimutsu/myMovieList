//
//  MainPageDataModel.swift
//  myMovieList
//
//  Created by Yagiz Ugur on 22.07.2019.
//  Copyright © 2019 Yagimutsu. All rights reserved.
//

import Foundation
import UIKit

struct Genre: Decodable {
    var id: Int
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
}

struct GenreIDs: Decodable {
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
}

struct Movie: Decodable {
    var title: String
    var poster_path: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case poster_path = "poster_path"
        //case id = "id"
        
        //case genre_ids = "genre_ids"
    }
    
    
}

struct MovieDatas: Decodable {
    var results: [Movie]?

    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
}

struct MoviePages {
    
    var page: [MovieDatas]
    
}
